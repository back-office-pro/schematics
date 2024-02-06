# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Jsonb
        class Component < Code::Component
          def translated? = false

          def language = 'json'
        end
      end
    end
  end
end
