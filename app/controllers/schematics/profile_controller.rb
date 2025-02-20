# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ProfileController < ApplicationController
    include Fillable
    helper_method :attributes

    def edit; end

    def update
      result = Resources::Update.call(resource: current_user, resource_params:)
      switch_localization { respond_with result, location: edit_profile_path }
    end

    private

    def attributes = entity
      .fillable_elements
      .insert(2, password_challenge_attribute)

    def password_challenge_attribute = Attributes::Digest.new(
      entity:,
      name: 'password_challenge',
      options: { required: true }
    )

    def model_class = ::User

    def permitted_params = super.push(:password_challenge)
  end
end
