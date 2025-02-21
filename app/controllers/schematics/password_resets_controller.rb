# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class PasswordResetsController < ApplicationController
    include Fillable

    allow_unauthenticated_access
    before_action :set_user, only: %i[edit update]

    rate_limit to: 5, within: 1.minute, only: :create

    layout 'schematics/jumbotron'

    delegate :human_name, :gender, to: :model_class, private: true

    def new; end

    def edit; end

    def create
      result = PasswordResets::Create.call(
        **resource_params,
        url_options: current_tenant.default_url_options
      )
      respond_with result, location: main_app.login_path
    end

    def update
      result = Resources::Update.call(resource: @user, resource_params:)
      respond_with result, location: main_app.login_path
    end

    private

    def set_user
      @user = model_class.with_role.find_by_token_for(:new_account, params[:token]) ||
              model_class.with_role.find_by_password_reset_token!(params[:token]) # rubocop:disable Rails/DynamicFindBy
    end

    def model_class = ::User

    def permitted_params = %i[email password password_confirmation]

    def index_path = new_password_reset_path
  end
end
