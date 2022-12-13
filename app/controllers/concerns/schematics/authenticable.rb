# frozen_string_literal: true

module Schematics
  module Authenticable
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_user!
      before_action :touch_session!
      helper_method :current_user, :current_session
    end

    private

    def auth_token = http_token || cookies.permanent.encrypted[:auth_token]

    def authenticate_user!
      return unless current_session.is_a?(Guest::Session)

      respond_to do |format|
        format.json { head :unauthorized }
        format.any do
          store_location
          redirect_to main_app.login_path,
                      alert: t('schematics.application.authenticate_user.alert')
        end
      end
    end

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end

    def current_session
      ::Session.authorized_by(auth_token, session[:current_session_id]).first ||
        ::ApiKey.active.find_by(auth_token:) ||
        Guest::Session.new(request:)
    end

    def current_user
      @current_user ||= current_session.user
    end

    def http_token = authenticate_with_http_token(&::JsonWebToken.method(:decode))

    def store_location
      return unless request.get? || request.head?
      return unless request.local?

      session[:return_to] = request.original_url
    end

    def touch_session!
      current_session.touch!(request)
    end
  end
end
