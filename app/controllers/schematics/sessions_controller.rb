module Schematics
  class SessionsController < ApplicationController
    include Fillable
    before_action :authorize, only: %i[edit update]
    layout 'schematics/auth', only: %i[new create]
    delegate :entity, to: :model_class, private: true
    helper_method :attributes

    def new
    end

    def edit
    end

    def create
      result = Sessions::Create.call(
        user_params: resource_params,
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
        resource_params: resource_params,
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

    def model_class
      User
    end

    def current_password_attribute
      Attributes::Attribute.create(entity, type: 'string', name: 'current_password')
    end

    def attributes
      entity
        .fillable_elements
        .insert(2, current_password_attribute)
        .reject_is_a?(Attributes::Association)
    end
  end
end
