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
      current_ability:,
      omniauth: request.env['omniauth.auth']
    )
    respond_with do |format|
      if result.success?
        session[:current_session_id] = result.current_session_id
        format.html { redirect_to @return_to_path || root_path, notice: t(result.message) }
        format.json { render json: { auth_token: result.jwt } }
      else
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
