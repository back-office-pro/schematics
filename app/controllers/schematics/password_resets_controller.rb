module Schematics
  class PasswordResetsController < ApplicationController
    skip_before_action :authorize
    before_action :set_user, only: [:edit, :update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    layout "schematics/auth"

    def new
    end

    def create
      user = User.find_by_email(user_params[:email])
      if user
        user.regenerate_password_reset_token
        UserMailer.password_reset(user).deliver_now
        redirect_to login_path, notice: t('.email_sent')
      else
        flash.now[:alert] = t('.unknown_email')
        render :new
      end
    end

    def edit
    end

    def update
      if @user.updated_at < 2.hours.ago
        redirect_to password_lost_path, alert: t('.expired')
      elsif @user.update(user_params)
        @user.password_reset_token = nil
        @user.save!
        redirect_to login_path, notice: t('.password_reset')
      else
        render :edit
      end
    end

    def not_found
      redirect_to password_lost_path, alert: t('.user_not_found')
    end

    private

    def set_user
      @user = User.find_by_password_reset_token!(params[:id])
    end

    def user_params
      params.require(:user).permit(*SCHEMA.find_entity_by_type('user').permitted_params)
    end
  end
end
