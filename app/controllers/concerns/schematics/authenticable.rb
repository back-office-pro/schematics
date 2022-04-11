# frozen_string_literal: true

module Schematics
  module Authenticable
    extend ActiveSupport::Concern

    included do
      before_action :authorize
      helper_method :current_user
    end

    private

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end

    def current_user
      @current_user ||= ::User
                        .includes(avatar_attachment: [blob: :variant_records], role: :permissions)
                        .find_by(auth_token: cookies[:auth_token] || auth_token&.dig(:auth_token))
    end

    def auth_token
      @auth_token ||= ::JsonWebToken.decode(request.headers['Authorization']&.split(' ')&.last)
    end

    def authorize
      return if current_user

      respond_to do |format|
        format.json { head :unauthorized }
        format.any do
          store_redirect_to_location
          redirect_to schematics.login_path, alert: t('schematics.application.authorize.alert')
        end
      end
    end

    def store_redirect_to_location
      return unless request.get?
      return unless request.local?

      session[:redirect_to] = request.original_url
    end
  end
end
