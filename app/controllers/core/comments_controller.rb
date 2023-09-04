# frozen_string_literal: true

class CommentsController < Schematics::ResourcesController
  include Schematics::Nestable

  protected

  def resource_path = polymorphic_path(record, comments: '').chop

  def index_path = resource_path

  def parent_model_name
    @resource.try(:record_type) || super
  end

  def record
    @resource.try(:record) || super
  end

  def resource_defaults = super.merge(record:)
end
