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
      if result.success?
        respond_to do |format|
          format.html do
            switch_locale do
              switch_beginning_of_week do
                switch_time_zone do
                  redirect_to edit_profile_path, notice: t(result.message)
                end
              end
            end
          end
          format.json
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :edit, status: :unprocessable_entity
          end
          format.json do
            render json: { errors: [t(result.message)] }, status: :unprocessable_entity
          end
        end
      end
    end

    private

    def attributes = entity
      .fillable_elements
      .insert(2, password_challenge_attribute)
      .reject_is_a?(Attributes::Association, Associations::Association)

    def password_challenge_attribute = Attributes::Digest.new(
      entity:,
      name: 'password_challenge',
      options: { required: true }
    )

    def model_class = ::User

    def permitted_params = super
      .excluding(:role_id)
      .push(:password_challenge)
  end
end
