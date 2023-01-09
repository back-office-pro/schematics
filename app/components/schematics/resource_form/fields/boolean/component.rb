# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Boolean
        class Component < Fields::Component
          def wrapper_class
            return unless inline?

            'mb-none'
          end
        end
      end
    end
  end
end
