# frozen_string_literal: true

class SessionsController < Schematics::ResourcesController
  before_action :logout_user!, only: :create
  skip_before_action :authenticate_user!, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
  layout 'schematics/jumbotron', only: %i[new create]

  def create
    result = Core::Sessions::Create.call(
      resource_params:,
      cookies:,
      current_session:,
      current_ability:
    )
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

  def i18n_title_path = 'sessions'

  def permitted_params = %i[email password remember_me]
end
