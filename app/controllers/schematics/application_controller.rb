# frozen_string_literal: true

module Schematics
  class ApplicationController < ::ApplicationController
    include Pagy::Backend

    protect_from_forgery unless: -> { request.format.json? }

    before_action :authorize
    before_action :set_paper_trail_whodunnit
    around_action :switch_locale
    after_action { pagy_headers_merge(@pagy) if @pagy }

    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from CanCan::AccessDenied, with: :forbidden

    helper_method :current_user

    def parameter_missing(exception)
      respond_to do |format|
        format.html do
          redirect_back fallback_location: schematics.root_path,
                        alert: t('schematics.application.parameter_missing.alert')
        end
        format.json do
          render json: { errors: [{ exception.param => ['parameter is required'] }] },
                 status: :bad_request
        end
      end
    end

    def not_found
      respond_to do |format|
        alert = t('schematics.application.not_found.alert', model_name: model_name.human)
        redirect_path = try(:not_found_path) || polymorphic_path(model_class)
        format.html { redirect_to redirect_path, alert: alert }
        format.json { head :not_found }
      end
    end

    def forbidden
      respond_to do |format|
        format.html do
          redirect_to schematics.root_path,
                      alert: t('schematics.application.forbidden.alert')
        end
        format.json { head :forbidden }
      end
    end

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
          redirect_to schematics.login_path, alert: t('schematics.application.forbidden.alert')
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
