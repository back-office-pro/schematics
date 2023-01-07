# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Attachments
        class Component < Fields::Component
          delegate :validators, :extensions, to: :field

          alias accept extensions

          def multiple = true

          def help = render AttachmentValidators::Component.new(validators:)
        end
      end
    end
  end
end
