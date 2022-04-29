# frozen_string_literal: true

module MainApp
  module SessionsController
    extend ActiveSupport::Concern

    prepended do
      skip_before_action :authenticate_user!, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
      layout 'schematics/auth', only: %i[new create]

      api :create, 'Create a session' do
        data 'session[email]', ::String, required: true
        data 'session[password]', ::String, required: true
        data 'session[remember_me]', 'boolean'
        response 200, 'Success', :json
        response 401, 'Not Authorized', :json
      end
    end

    def create
      result = Sessions::Create.call(resource_params:, cookies:, current_session:)
      if result.success?
        session[:current_session_id] = result.current_session_id
        respond_to do |format|
          format.html { redirect_to session[:return_to] || root_path, notice: t(result.message) }
          format.json { render json: { auth_token: result.jwt } }
        end
      else
        respond_to do |format|
          format.html do
            flash.now[:alert] = t(result.message)
            render :new, status: :unauthorized
          end
          format.json { head :unauthorized }
        end
      end
    end

    private

    def i18n_title_path
      'sessions'
    end

    def permitted_params
      %i[email password remember_me]
    end
  end
end
