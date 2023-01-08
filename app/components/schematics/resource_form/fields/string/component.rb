# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module String
        class Component < Fields::Component
          delegate :options, to: :field, private: true
          delegate :limit, :min, :length, to: :options, private: true

          def maxlength
            length || limit
          end

          def minlength
            length || min
          end
        end
      end
    end
  end
end
