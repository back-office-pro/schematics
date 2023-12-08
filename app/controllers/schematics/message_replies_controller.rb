# frozen_string_literal: true

module Schematics
  class MessageRepliesController < ResourcesController
    include Nestable

    skip_authorize_resource
    before_action -> { authorize!(:reply, record) }

    class << self
      def model_class = ::Message
    end

    def new
      @resource = record.new_reply
    end

    private

    def resource_defaults = super.merge(parent: record)
  end
end
