module Schematics
  class PasswordResetsController < ApplicationController
    skip_before_action :authorize
    before_action :set_user, only: [:edit, :update]
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    layout "schematics/auth"

    def new
    end

    def create
      if user = User.find_by_email(params[:email])
        user.regenerate_password_reset_token
        UserMailer.password_reset(user).deliver_now
        redirect_to login_path, notice: "Email sent with password reset instructions."
      else
        flash.now[:alert] = "E-mail inconnu."
        render :new
      end
    end
    
    def edit
    end
    
    def update
      if @user.updated_at < 2.hours.ago
        redirect_to password_lost_path, alert: "Password reset has expired."
      elsif @user.update_attributes(params[:user])
        redirect_to root_path, notice: "Password has been reset!"
      else
        render :edit
      end
    end

    def not_found
      redirect_to password_lost_path, alert: "User not found."
    end

    private

    def set_user
      @user = User.find_by_password_reset_token!(params[:id])
    end
  end
end
