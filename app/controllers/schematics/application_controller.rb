module Schematics
  class ApplicationController < ::ApplicationController
    protect_from_forgery unless: -> { request.format.json? }
    before_action :authorize
    around_action :switch_locale
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

    def switch_locale(&action)
      locale = current_user&.locale&.first(2)&.downcase ||
        extract_locale_from_accept_language_header ||
        I18n.default_locale
      I18n.with_locale(locale, &action)
    end

    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
    end
  end
end
