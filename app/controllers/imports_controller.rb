# frozen_string_literal: true

class ImportsController < Schematics::ResourcesController
  include Schematics::Nestable

  skip_authorize_resource only: %i[new create]
  before_action -> { authorize!(:import, parent_model_class) }, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter

  def new
    super
    respond_to do |format|
      format.html
      format.csv do
        Schematics::GenerateCsvTemplateJob.perform_later(current_user, parent_model_class)
        head :accepted
      end
    end
  end

  protected

  def i18n_title_path = 'imports'

  def resource_defaults
    super.merge(model: parent_model_class.to_s)
  end
end
