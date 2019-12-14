module Schematics
  class ApplicationController < ::ApplicationController
    protect_from_forgery unless: -> { request.format.json? }
    before_action :authorize
    helper_method :current_user

    private

    def current_user
      respond_to do |format|
        format.html { @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token] }
        format.json { @current_user ||= User.find_by_auth_token!(auth_token[:auth_token]) if auth_token }
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
          format.html { redirect_to login_path, alert: "Not authorized" }
          format.json { head :unauthorized }
        end
      end
    end
  end
end
