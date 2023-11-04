# frozen_string_literal: true

module Schematics
  class OneTimePasswordController < ApplicationController
    include Fillable
    before_action :require_sudo!, only: :edit

    def edit; end

    def update
      result = OneTimePassword::Update.call(user: current_user, resource_params:)
      respond_with result, location: edit_one_time_password_path
    end

    def destroy
      result = OneTimePassword::Destroy.call(user: current_user)
      respond_with result, location: edit_one_time_password_path, redirect_on_failure: true
    end

    private

    def model_class = ::User

    def permitted_params = %i[otp_attempt]
  end
end
