module Schematics
  class SessionsController < ApplicationController
    before_action :authorize, only: [:edit, :update]
    layout "schematics/auth", only: [:new, :create]

    def new
    end

    def edit
    end
    
    def create
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        if params[:remember_me]
          cookies.permanent[:auth_token] = user.auth_token
        else
          cookies[:auth_token] = user.auth_token
        end
        redirect_to root_path, notice: "Logged in!"
      else
        flash.now[:alert] = "Email or password is invalid"
        render :new
      end
    end

    def update
      if current_user.authenticate(params[:user][:current_password]) 
        if current_user.update(user_params)
          redirect_to profile_path, notice: "Your profile was successfully updated"
        else
          render :edit
        end
      else
        flash.now[:alert] = "Wrong password"
        render :edit
      end
    end

    def destroy
      cookies.delete(:auth_token)
      redirect_to login_path, notice: "Logged out!"
    end

    private

    def user_params
      params.require(:user).permit(*SCHEMA.find_entity_by_type('user').permitted_params)
    end
  end
end
