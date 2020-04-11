module Schematics
  class ApplicationController < ::ApplicationController
    protect_from_forgery unless: -> { request.format.json? }
    before_action :authorize
    before_action :set_locale
    helper_method :current_user

    private

    def current_user
      if cookies[:auth_token]
        @current_user ||= User.find_by_auth_token(cookies[:auth_token])
      elsif auth_token
        @current_user ||= User.find_by_auth_token(auth_token[:auth_token])
      end
    end

    def auth_token
      @auth_token ||= JsonWebToken.decode(request.headers['Authorization'].split(' ').last)
    rescue
      nil
    end

    def authorize
      if current_user.nil?
        respond_to do |format|
          format.json { head :unauthorized }
          format.any do
            redirect_to login_path, alert: t('schematics.application.authorize.unauthorized_access')
          end
        end
      end
    end

    def set_locale
      I18n.locale = current_user&.locale&.to_sym ||
        request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first ||
        I18n.default_locale
    end
  end
end
