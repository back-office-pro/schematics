module Schematics
  class SessionsController < ApplicationController
    before_action :authenticate_user!, only: [:edit, :update]
    layout "schematics/auth", only: :new

    def new
    end

    def edit
    end
    
    def create
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_url, notice: "Logged in!"
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
      session[:user_id] = nil
      redirect_to root_url, notice: "Logged out!"
    end

    private

    def entity_name
      "user"
    end

    def entity
      SCHEMA.find_entity_by_type(entity_name)
    end

    def user_params
      params.require(entity_name.to_sym).permit(*entity.permitted_params)
    end
  end
end
