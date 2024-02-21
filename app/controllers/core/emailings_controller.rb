# frozen_string_literal: true

class EmailingsController < Schematics::ResourcesController
  include Schematics::Nestable

  protected

  def parent_model_name
    @resource.try(:record_type) || super
  end

  def record
    @resource.try(:record) || super
  end

  def resource_defaults = super.merge(record:)
end
