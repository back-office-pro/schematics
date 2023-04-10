# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Text
        class Component < Fields::Component
          delegate :options, :translated?, to: :field, private: true

          def data = { controller: 'autosize' }
        end
      end
    end
  end
end
