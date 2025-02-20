# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class SessionsController < Schematics::ResourcesController
  before_action :logout_user!, only: :create

  allow_unauthenticated_access only: %i[new create]
  skip_before_action :set_draft, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :no_store, only: :create

  rate_limit to: 5, within: 20.seconds, only: :create

  layout 'schematics/jumbotron', only: %i[new create]

  def create
    result = Core::Sessions::Create.call(
      resource_params:,
      cookies:,
      session: current_session,
      ability: current_ability
    )
    respond_with do |format|
      if result.success?
        if result.otp_token
          session[:otp_token] = result.otp_token
          session[:session_remember_me] = resource_params[:remember_me]
          format.html { redirect_to schematics.new_one_time_passwords_path, notice: t(result.message) } # rubocop:disable Layout/LineLength
          format.json { render json: { otp_token: result.otp_token } }
        else
          session[:current_session_id] = result.session.id
          format.html { redirect_to return_to_path, notice: t(result.message) }
          format.json { render json: Schematics::AuthToken.new(result.session) }
        end
      else
        format.html do
          flash.now[:alert] = t(result.message)
          render :new, status: :unauthorized
        end
        format.json { request_http_token_authentication }
      end
    end
  end

  private

  def model_name = 'Session'

  def permitted_params = %i[email password remember_me]

  def resource_params
    request.env['omniauth.auth']&.info || super
  end
end
