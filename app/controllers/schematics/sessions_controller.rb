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
      result = Sessions::Create.call(
        user_params: user_params,
        cookies: cookies,
        remember_me: params[:user][:remember_me]
      )
      if result.success?
        respond_to do |format|
          format.html { redirect_to root_path, notice: t(result.message) }
          format.json { render json: { auth_token: result.jwt } }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :new
          end
          format.json { head :unauthorized }
        end
      end
    end

    def update
      result = Sessions::Update.call(
        resource_params: user_params,
        resource: current_user,
        password: params[:user][:current_password]
      )
      if result.success?
        respond_to do |format|
          format.html do
            switch_locale do
              redirect_to profile_path, notice: t(result.message)
            end
          end
          format.json
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :edit
          end
          format.json { render json: current_user.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      result = Sessions::Destroy.call(cookies: cookies)
      if result.success?
        redirect_to login_path, notice: t(result.message)
      else
        redirect_to root_path, alert: t(result.message)
      end
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
