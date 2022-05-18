# frozen_string_literal: true

module Schematics
  module Authenticable
    extend ActiveSupport::Concern

    included do
      before_action :authenticate_user!
      before_action :touch_session!, unless: -> { request.format.json? }
      helper_method :current_user, :current_session
    end

    private

    def auth_token
      ::JsonWebToken.decode(authorization_header)&.dig(:auth_token) ||
        cookies.permanent.encrypted[:auth_token]
    end

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

    def authorization_header = request
      .headers['Authorization']
      &.split(' ')
      &.last

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end

    def current_session
      ::Session
        .includes(:slugs)
        .includes(user: :slugs)
        .with_user_avatar
        .with_user_permissions
        .with_user_drafts
        .where(auth_token:)
        .or(::Session.active.where(id: session[:current_session_id]))
        .load_async
        .first || Guest::Session.new(request:)
    end

    def current_user
      @current_user ||= current_session.user
    end

    def store_location
      return unless request.get? || request.head?
      return unless request.local?

      session[:return_to] = request.original_url
    end

    def touch_session!
      current_session.update!(updated_at: ::Time.current)
    end
  end
end
