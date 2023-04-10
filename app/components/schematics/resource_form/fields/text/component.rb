# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Text
        class Component < Fields::Component
          delegate :options, to: :field, private: true
          delegate :translated?, to: :options

          def data = { controller: 'autosize' }
        end
      end
    end
  end
end
