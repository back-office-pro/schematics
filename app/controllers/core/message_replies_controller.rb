# frozen_string_literal: true

class MessageRepliesController < Schematics::ResourcesController
  include Schematics::Nestable
  before_action -> { authorize!(:reply, model_class) }

  def new
    @resource = model_class.from(record)
  end

  private

  def resource_path = message_path(@resource)

  def resource_defaults = super.merge(parent: record)
end
