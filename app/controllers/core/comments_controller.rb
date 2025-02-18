# frozen_string_literal: true

class CommentsController < Schematics::ResourcesController
  include Schematics::Nestable

  before_action -> { authorize!(:comment, parent_model_class) }

  protected

  def model_name = 'Comment'

  def show_path = resource_path(record, comments: '').chop

  def index_path = show_path

  def parent_model_name
    @resource.try(:record_type) || super
  end

  def record
    @resource.try(:record) || super
  end

  def resource_defaults = super.merge(record:)
end
