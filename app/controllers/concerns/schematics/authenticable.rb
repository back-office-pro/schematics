# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Authenticable
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_user!
      around_action :touch_session!
      helper_method :current_user, :current_session
    end

    class_methods do
      def allow_unauthenticated_access(**)
        skip_before_action(:authenticate_user!, **)
      end
    end

    private

    def access_token = http_token || cookies.permanent.encrypted[:access_token]

    def http_token = authenticate_with_http_token(&Session.method(:decode_access_token))

    def api_key = request.headers['x-api-key']

    def authenticate_user!
      return unless current_session in Guest::Session

      respond_to do |format|
        format.json { request_http_token_authentication }
        format.any do
          store_location
          redirect_to main_app.login_path,
                      alert: t('schematics.application.authenticate_user.alert')
        end
      end
    end

    def current_ability
      @current_ability ||= begin
        ability = Ability.new(current_user, ::SchemaCache)
        ability.merge(DemoAbility.new) if ApplicationRecord.current_shard.eql?(:demo)
        ability
      end
    end

    def current_session
      ::Session.authorized_by(access_token, session[:current_session_id]).first ||
        ::APIKey.with_permissions.active.find_by(access_token: api_key) ||
        Guest::Session.new(request:)
    end

    def store_location
      return unless request.get? || request.head?
      return unless request.local?

      session[:return_to] = request.original_url
    end

    def current_user
      @current_user ||= current_session.user
    end

    def touch_session!(&)
      current_session.touch!(request, response, Benchmark.realtime(&))
    end

    def logout_user!
      session.delete(:current_session_id)
      cookies.delete(:access_token)
    end

    def return_to_path = session
      .fetch(:return_to, schematics.root_path)
      .tap { session.delete(:return_to) }
  end
end
