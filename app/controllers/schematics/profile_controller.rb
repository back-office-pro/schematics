# frozen_string_literal: true

module Schematics
  class ProfileController < ApplicationController
    include Fillable
    delegate :entity, to: :model_class, private: true
    helper_method :attributes

    def edit; end

    def update
      result = Profile::Update.call(
        current_session:,
        current_ability:,
        resource_params: resource_params.except(:password_challenge),
        resource: current_user,
        password: resource_params[:password_challenge]
      )
      switch_locale do
        switch_beginning_of_week do
          switch_time_zone do
            respond_with result, location: edit_profile_path
          end
        end
      end
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
