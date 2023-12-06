# frozen_string_literal: true

class MessageRepliesController < Schematics::ResourcesController
  include Schematics::Nestable

  def new
    @resource = model_class.from(record)
  end

  def resource_path = message_path(@resource)

  private

  def resource_defaults = super.merge(parent: record)
end
