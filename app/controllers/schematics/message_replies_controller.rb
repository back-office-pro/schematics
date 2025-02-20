# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class MessageRepliesController < ResourcesController
    include Nestable
    include ResourcesHelper

    skip_authorize_resource
    before_action -> { authorize!(:reply, record) }
    helper_method :attributes

    def new
      @resource = record.new_reply
    end

    private

    def model_name = 'Message'

    def parent_model_name = model_name

    def attributes = entity.rich_text_attributes

    def resource_defaults = super.merge(
      subject: record.new_reply.subject,
      recipients: record.new_reply.recipients,
      parent: record
    )
  end
end
