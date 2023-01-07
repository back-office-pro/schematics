# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Attachment
        class Component < Fields::Component
          delegate :validators, :extensions, :attributes_param_key, to: :field
          delegate :attached?, to: :value
          renders_one_form :form

          alias accept extensions

          def help = render AttachmentValidators::Component.new(validators:)
        end
      end
    end
  end
end
