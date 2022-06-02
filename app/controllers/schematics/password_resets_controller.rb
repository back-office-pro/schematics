# frozen_string_literal: true

module Schematics
  class PasswordResetsController < ApplicationController
    include Fillable

    skip_before_action :authenticate_user!
    before_action :set_user, only: %i[edit update]
    layout 'schematics/auth'
    delegate :entity, :human_name, :gender, to: :model_class, private: true

    def create
      result = PasswordResets::Create.call(resource_params)
      if result.success?
        respond_to do |format|
          format.html { redirect_to main_app.login_path, notice: t(result.message) }
          format.json
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :new, status: :unprocessable_entity
          end
          format.json do
            render json: { errors: [t(result.message)] },
                   status: :unprocessable_entity
          end
        end
      end
    end

    def edit; end

    def new; end

    def update
      result = PasswordResets::Update.call(user: @user, user_params: resource_params)
      if result.success?
        respond_to do |format|
          format.html { redirect_to main_app.login_path, notice: t(result.message) }
          format.json
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :edit, status: :unprocessable_entity
          end
          format.json do
            render json: { errors: [t(result.message)] },
                   status: :unprocessable_entity
          end
        end
      end
    end

    private

    def model_class = ::User

    def set_user
      @user = model_class.find_by!(password_reset_token: params[:token])
    end

    alias index_path new_password_reset_path
  end
end
