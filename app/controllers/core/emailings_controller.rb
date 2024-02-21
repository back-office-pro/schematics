# frozen_string_literal: true

class EmailingsController < Schematics::ResourcesController
  include Schematics::Nestable

  skip_authorize_resource only: %i[new create]
  before_action -> { authorize!(:show, record) }, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter

  protected

  def parent_model_name
    @resource.try(:record_type) || super
  end

  def record
    @resource.try(:record) || super
  end

  def resource_defaults = super.merge(record:)
end
