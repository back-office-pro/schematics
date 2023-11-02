# frozen_string_literal: true

module Schematics
  class OneTimePasswordController < ApplicationController
    before_action :require_sudo!, only: :edit

    def edit
      @resource = OneTimePassword.new(user: current_user)
    end

    def update
      @resource = OneTimePassword.new(user: current_user, **resource_params)
      result = OneTimePasswords::Update.call(resource: @resource)
      respond_with result, location: edit_one_time_password_path
    end

    def destroy
      result = Resources::Update.call(resource: current_user, resource_params: { otp_secret: nil })
      respond_with result, location: edit_one_time_password_path, redirect_on_failure: true
    end

    private

    def resource_params = params
      .require(:one_time_password)
      .permit(:secret, :attempt)
  end
end
