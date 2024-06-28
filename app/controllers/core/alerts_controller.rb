# frozen_string_literal: true

class AlertsController < Schematics::ResourcesController
  include Schematics::Nestable

  skip_authorize_resource only: %i[new create]
  before_action -> { authorize!(:alert, parent_model_class) }, only: %i[new create] # rubocop:disable Rails/LexicallyScopedActionFilter

  protected

  def record
    @resource.try(:record) || super
  end

  def resource_defaults = super.merge(record:)
end
