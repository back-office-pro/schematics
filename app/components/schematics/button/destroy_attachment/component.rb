# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Button
    module DestroyAttachment
      class Component < ApplicationComponent
        delegate :name, :record, to: :attachment
        delegate :attributes_param_key, to: :field
        option :attachment

        def field = record
          .class
          .entity
          .find_field_by_name(name)

        def url = resource_path(record)

        def target = "confirm-dialog-#{record.id}-#{attachment.id}"

        def title = t('schematics.application.button.destroy')

        def render?
          can?(:destroy, attachment) && attachment in ::ActiveStorage::Attachment
        end
      end
    end
  end
end
