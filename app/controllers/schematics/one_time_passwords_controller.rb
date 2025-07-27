# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class OneTimePasswordsController < ApplicationController
    include Fillable

    allow_unauthenticated_access only: %i[new create]
    before_action :require_sudo!, only: %i[show edit]
    before_action :no_store, only: %i[show create]
    layout 'schematics/jumbotron', only: %i[new create]

    def show
      if current_user.otp_enabled?
        respond_to do |format|
          format.json { render json: { codes: current_user.otp_backup_codes } }
          format.html
        end
      else
        respond_to do |format|
          format.json { head :no_content }
          format.html { redirect_to(edit_one_time_passwords_path) }
        end
      end
    end

    def new
      @user = model_class.find_by_token_for!(:one_time_password, session[:otp_token])
    end

    def edit; end

    def create
      @user = model_class.find_by_token_for!(
        :one_time_password,
        resource_params_with_defaults[:otp_token]
      )
      result = OneTimePasswords::Create.call(
        user: @user,
        session: current_session,
        cookies:,
        resource_params:
      )
      respond_to do |format|
        if result.success?
          session[:current_session_id] = result.session.id
          format.html { redirect_to return_to_path, status: :see_other, notice: t(result.message) }
          format.json { render json: AuthToken.new(result.session) }
        else
          format.html do
            flash.now[:alert] = t(result.message)
            render :new, status: :unauthorized
          end
          format.json { request_http_token_authentication }
        end
      end
    end

    def update
      result = OneTimePasswords::Authenticate.call(user: current_user, resource_params:)
      respond_with result, location: one_time_passwords_path
    end

    def destroy
      result = OneTimePasswords::Destroy.call(user: current_user)
      respond_with result, location: edit_one_time_passwords_path
    end

    private

    def index_path = root_path

    def model_class = ::User

    def permitted_params = [:remember_me, :otp_token, { otp_attempt_digits: [] }]

    def resource_defaults = {
      otp_token: session[:otp_token],
      remember_me: session[:session_remember_me]
    }
  end
end
