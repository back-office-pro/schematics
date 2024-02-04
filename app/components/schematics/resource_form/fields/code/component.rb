# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Code
        class Component < Jsonb::Component
          delegate :translated?, :language, to: :field
        end
      end
    end
  end
end
