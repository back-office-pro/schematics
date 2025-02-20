# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Attachment
        class Component < Fields::Component
          delegate :validators, :attributes_param_key, to: :field
          delegate :attached?, to: :value

          def accept = options
            .content_type
            &.join(',')

          def help = __attachment_validator(validators.human)

          def label = t('helpers.label.destroy')

          def wrapper_class = 'text-secondary float-end me-0'

          def required
            super unless attached?
          end

          def data = {
            action: 'change->attachments-previewer#preview',
            'attachments-previewer-target': 'input'
          }
        end
      end
    end
  end
end
