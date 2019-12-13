module Schematics
  class ApplicationController < ::ApplicationController
    protect_from_forgery unless: -> { request.format.json? }
    before_action :authorize
    helper_method :current_user

    private

    def current_user
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    end

    def authorize
      redirect_to login_path, alert: "Not authorized" if current_user.nil?
    end
  end
end
