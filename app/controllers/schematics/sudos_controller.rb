# frozen_string_literal: true

module Schematics
  class SudosController < ApplicationController
    def new; end

    def create
      if current_user.authenticate(resource_params[:password])
        current_session.sudo!
        return_to_path = session[:return_to]
        session.delete(:return_to)
        redirect_to return_to_path
      else
        render :new
      end
    end

    private

    def resource_params = params
      .require(:user)
      .permit(:password)
  end
end
