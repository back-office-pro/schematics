# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Attachment
        class Component < Fields::Component
          delegate :validators, :extensions, :attributes_param_key, to: :field
          delegate :attached?, to: :value

          alias accept extensions

          def help = render AttachmentValidators::Component.new(validators:)

          def required
            super unless value.attached?
          end
        end
      end
    end
  end
end
