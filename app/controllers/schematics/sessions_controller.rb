module Schematics
  class SessionsController < ApplicationController
    before_action :authorize, only: [:show, :edit, :update]
    layout "schematics/auth", only: [:new, :create]
    swagger_controller :sessions, "Sessions Management"
    helper_method :entity

    def new
    end

    def edit
    end

    def show
      current_user.touch
      render json: current_user
    end

    swagger_api :create do |api|
      summary "User login"
      param :form, "user[email]", :string, :required, "Email address"
      param :form, "user[password]", :string, :required, "Password"
      response :success
      response :unauthorized
    end

    def create
      user = User.find_by_email(user_params[:email])
      authenticated = user&.authenticate(user_params[:password])
      respond_to do |format|
        format.html do
          if authenticated
            if params[:user][:remember_me]
              cookies.permanent[:auth_token] = user.auth_token
            else
              cookies[:auth_token] = user.auth_token
            end
            redirect_to root_path, notice: t('.logged_in')
          else
            flash.now[:alert] = t('.invalid_credentials')
            render :new
          end
        end
        format.json do
          if authenticated
            render json: { auth_token: JsonWebToken.encode(auth_token: user.auth_token) }
          else
            head :unauthorized
          end
        end
      end
    end

    def update
      if current_user.authenticate(params[:user][:current_password])
        if current_user.update(user_params)
          switch_locale do
            redirect_to profile_path, notice: t('.profile_updated')
          end
        else
          render :edit
        end
      else
        flash.now[:alert] = t('.wrong_password')
        render :edit
      end
    end

    def destroy
      cookies.delete(:auth_token)
      redirect_to login_path, notice: t('.logged_out')
    end

    private

    def user_params
      params.require(:user).permit(*entity.permitted_params)
    end

    def entity
      User.entity
    end
  end
end
