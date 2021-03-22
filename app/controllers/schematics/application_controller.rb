module Schematics
  class ApplicationController < ::ApplicationController
    include Pagy::Backend
    protect_from_forgery unless: -> { request.format.json? }
    before_action :authorize
    around_action :switch_locale
    helper_method :current_user

    private

    def current_ability
      @current_ability ||= Ability.new(current_user)
    end

    def current_user
      @current_user ||= User
                        .includes(avatar_attachment: [blob: :variant_records], role: :permissions)
                        .find_by(auth_token: cookies[:auth_token] || auth_token&.dig(:auth_token))
    end

    def auth_token
      @auth_token ||= JsonWebToken.decode(request.headers['Authorization']&.split(' ')&.last)
    end

    def authorize
      return if current_user.present?
      respond_to do |format|
        format.json { head :unauthorized }
        format.any do
          redirect_to schematics.login_path,
                      alert: t('schematics.resources.forbidden.alert')
        end
      end
    end

    def switch_locale(&action)
      locale = current_user&.locale&.downcase ||
               extract_locale_from_accept_language_header ||
               I18n.default_locale
      I18n.with_locale(locale, &action)
    end

    def extract_locale_from_accept_language_header
      request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first
    end
  end
end
