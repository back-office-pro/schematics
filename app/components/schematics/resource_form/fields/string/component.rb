# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module String
        class Component < Fields::Component
          delegate :options, to: :field, private: true
          delegate :limit, :min, :length, :translated?, to: :options, private: true
          delegate :available_locales, to: 'Schematics::Engine.config.i18n'

          def maxlength
            length || limit
          end

          def minlength
            length || min
          end

          def label = resource
            .class
            .human_attribute_name(name)
        end
      end
    end
  end
end
