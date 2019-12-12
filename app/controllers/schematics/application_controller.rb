module Schematics
  class ApplicationController < ::ApplicationController
    protect_from_forgery unless: -> { request.format.json? }
    before_action :authenticate_user!
    helper_method :current_user

    private

    def current_user
      if session[:user_id]
        @current_user ||= User.find(session[:user_id])
      else
        @current_user = nil
      end
    end

    def authenticate_user!
      redirect_to login_url, alert: "Not authorized" if current_user.nil?
    end
  end
end
