# frozen_string_literal: true

module Schematics
  class OneTimePasswordsController < ApplicationController
    include Fillable

    skip_before_action :authenticate_user!, only: %i[new create]
    before_action :set_user, only: %i[new create]
    before_action :require_sudo!, only: %i[show edit]
    layout 'schematics/jumbotron', only: %i[new create]

    def show
      if current_user.otp_enabled?
        respond_with codes: current_user.otp_backup_codes
      else
        respond_with do |format|
          format.html { redirect_to(edit_one_time_passwords_path) }
        end
      end
    end

    def new; end

    def edit; end

    def create
      result = OneTimePasswords::Create.call(
        user: @user,
        session: current_session,
        cookies:,
        resource_params:
      )
      respond_with do |format|
        if result.success?
          session[:current_session_id] = result.current_session_id
          format.html { redirect_to return_to_path, notice: t(result.message) }
          format.json { render json: { auth_token: result.jwt } }
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
      respond_with result, location: edit_one_time_passwords_path, redirect_on_failure: true
    end

    private

    def index_path = root_path

    def model_class = ::User

    def permitted_params = %i[otp_attempt]

    def set_user
      @user = model_class
              .with_role
              .find_by_token_for!(:one_time_password, session[:otp_token])
    end
  end
end
