# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class ImportsController < Schematics::ResourcesController
  include Schematics::Nestable

  skip_authorize_resource only: %i[new create]
  before_action -> { authorize!(:import, parent_model_class) }, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter
  helper_method :attributes

  def new
    super
    respond_to do |format|
      format.html
      format.csv do
        Schematics::GenerateCSVTemplateJob.perform_later(current_user, parent_model_class)
        head :accepted
      end
    end
  end

  protected

  def model_name = 'Import'

  def attributes = entity
    .fillable_elements
    .grep_v(Schematics::Attributes::Jsonb)
    .map { |attribute| attribute.tap { it.options.merge!(required: true) } }

  def resource_defaults
    super.merge(model: parent_model_class.to_s)
  end
end
