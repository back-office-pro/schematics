# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Text
        class Component < Fields::Component
          delegate :limit, :min, :length, :translated?, to: :field

          def maxlength
            length || limit
          end

          def minlength
            length || min
          end

          def data = { controller: 'autosize' }
        end
      end
    end
  end
end
