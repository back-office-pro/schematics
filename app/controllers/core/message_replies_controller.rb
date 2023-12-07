# frozen_string_literal: true

class MessageRepliesController < Schematics::ResourcesController
  include Schematics::Nestable

  skip_authorize_resource
  before_action -> { authorize!(:reply, Message) }

  class << self
    def model_class = Message
  end

  def new
    @resource = record.new_reply
  end

  private

  def resource_defaults = super.merge(parent: record)
end
