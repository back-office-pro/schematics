# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
