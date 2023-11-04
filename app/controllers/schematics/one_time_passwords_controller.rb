# frozen_string_literal: true

module Schematics
  class OneTimePasswordsController < ApplicationController
    include Fillable
    before_action :require_sudo!, only: %i[show new]

    def show
      if current_user.otp_enabled?
        respond_with codes: current_user.otp_backup_codes
      else
        respond_with do |format|
          format.json
          format.html { redirect_to(new_one_time_passwords_path) }
        end
      end
    end

    def new; end

    def create
      result = OneTimePasswords::Create.call(user: current_user, resource_params:)
      respond_with result, location: one_time_passwords_path
    end

    def destroy
      result = OneTimePasswords::Destroy.call(user: current_user)
      respond_with result, location: new_one_time_passwords_path, redirect_on_failure: true
    end

    private

    def model_class = ::User

    def permitted_params = %i[otp_attempt]
  end
end
