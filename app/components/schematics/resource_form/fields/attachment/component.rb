# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Attachment
        class Component < Fields::Component
          delegate :validators, :extensions, :attributes_param_key, to: :field
          delegate :attached?, to: :value

          alias accept extensions

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
