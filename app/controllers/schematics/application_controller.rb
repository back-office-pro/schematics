# frozen_string_literal: true

module Schematics
  class ApplicationController < ::ApplicationController
    include Pagy::Backend
    include Localizable

    protect_from_forgery unless: -> { request.format.json? }
    before_action { Rack::MiniProfiler.authorize_request unless Rails.env.test? }
    before_action :authorize
    before_action :set_paper_trail_whodunnit
    after_action { pagy_headers_merge(@pagy) if @pagy }
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
      return if current_user

      respond_to do |format|
        format.json { head :unauthorized }
        format.any do
          redirect_to schematics.login_path, alert: t('schematics.application.authorize.alert')
        end
      end
    end
  end
end
