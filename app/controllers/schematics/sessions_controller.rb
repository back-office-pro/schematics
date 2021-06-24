# frozen_string_literal: true

module Schematics
  class SessionsController < ApiController
    include Fillable
    skip_before_action :authorize, only: %i[new create]
    layout 'schematics/auth', only: %i[new create]
    delegate :entity, to: :model_class, private: true
    helper_method :attributes
    DENYLIST = %i[role_id].freeze

    def new; end

    def edit; end

    def create
      result = Sessions::Create.call(
        user_params: resource_params,
        cookies: cookies
      )
      if result.success?
        respond_to do |format|
          format.html { redirect_to root_path, notice: t(result.message) }
          format.json { render json: { auth_token: result.jwt } }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :new
          end
          format.json { head :unauthorized }
        end
      end
    end

    def update
      result = Sessions::Update.call(
        resource_params: resource_params.except(*session_params),
        resource: current_user,
        password: resource_params[:current_password]
      )
      if result.success?
        respond_to do |format|
          format.html do
            switch_locale do
              switch_beginning_of_week do
                switch_time_zone do
                  redirect_to profile_path, notice: t(result.message)
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
            render :edit
          end
          format.json do
            render json: { errors: [t(result.message)] },
                   status: :unprocessable_entity
          end
        end
      end
    end

    def destroy
      result = Sessions::Destroy.call(cookies: cookies)
      if result.success?
        redirect_to login_path, notice: t(result.message)
      else
        redirect_to root_path, alert: t(result.message)
      end
    end

    private

    def model_class
      User
    end

    def session_params
      %i[remember_me current_password]
    end

    def permitted_params
      super
        .excluding(*DENYLIST)
        .concat(session_params)
    end

    def current_password_attribute
      Attributes::Attribute.create(entity, type: 'string', name: 'current_password')
    end

    def attributes
      entity
        .fillable_elements
        .insert(2, current_password_attribute)
        .reject_is_a?(Attributes::Association)
    end
  end
end
