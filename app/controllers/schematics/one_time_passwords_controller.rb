# frozen_string_literal: true

module Schematics
  class OneTimePasswordsController < ApplicationController
    before_action :require_sudo!, only: :new

    def new
      @resource = OneTimePassword.new(user: current_user)
    end

    def create
      @resource = OneTimePassword.new(resource_params)
      result = OneTimePasswords::Create.call(resource: @resource)
      respond_with result, location: new_one_time_password_path
    end

    def destroy
      result = Resources::Update.call(resource: current_user, resource_params: { otp_secret: nil })
      respond_with result, location: new_one_time_password_path, redirect_on_failure: true
    end

    private

    def resource_params = params
      .require(:one_time_password)
      .permit(:secret, :attempt)
      .with_defaults(user: :current_user)
  end
end
