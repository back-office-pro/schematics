# frozen_string_literal: true

module Schematics
  class PasswordResetsController < ApplicationController
    include Fillable

    skip_before_action :authenticate_user!
    before_action :set_user, only: %i[edit update]
    layout 'schematics/jumbotron'
    delegate :entity, :human_name, :gender, to: :model_class, private: true

    def new; end

    def edit; end

    def create
      result = PasswordResets::Create.call(resource_params)
      respond_with result, location: main_app.login_path
    end

    def update
      result = Resources::Update.call(resource: @user, resource_params:)
      respond_with result, location: main_app.login_path
    end

    private

    def model_class = ::User

    def permitted_params = %i[email password password_confirmation]

    def set_user
      @user = model_class
              .with_role
              .find_by_token_for!(:password_reset, params[:token])
    end

    def index_path = new_password_reset_path
  end
end
