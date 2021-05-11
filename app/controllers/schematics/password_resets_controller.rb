module Schematics
  class PasswordResetsController < ApplicationController
    include Fillable
    skip_before_action :authorize
    before_action :set_user, only: %i[edit update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    layout 'schematics/auth'
    delegate :entity, to: :model_class, private: true

    def new; end

    def create
      result = PasswordResets::Create.call(resource_params)
      if result.success?
        respond_to do |format|
          format.html { redirect_to login_path, notice: t(result.message) }
          format.json
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :new
          end
          format.json { render json: t(result.message), status: :unprocessable_entity }
        end
      end
    end

    def edit; end

    def update
      result = PasswordResets::Update.call(user: @user, user_params: resource_params)
      if result.success?
        respond_to do |format|
          format.html { redirect_to login_path, notice: t(result.message) }
          format.json
        end
      else
        respond_to do |format|
          format.html { redirect_to password_lost_path, alert: t(result.message) }
          format.json { render json: t(result.message), status: :unprocessable_entity }
        end
      end
    end

    def not_found
      respond_to do |format|
        format.html { redirect_to password_lost_path, alert: t('.user_not_found') }
        format.json { head :not_found }
      end
    end

    private

    def model_class
      User
    end

    def set_user
      @user = model_class.find_by!(password_reset_token: params[:id])
    end
  end
end
