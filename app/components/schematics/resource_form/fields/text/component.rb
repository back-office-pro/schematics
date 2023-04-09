# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Text
        class Component < Fields::Component
          delegate :options, to: :field, private: true
          delegate :translated?, to: :options
          delegate :available_locales, to: 'Schematics::Engine.config.i18n'

          def data = { controller: 'autosize' }

          def i18n_label(locale)
            t(".#{locale}", attribute_name: resource.class.human_attribute_name(name))
          end
        end
      end
    end
  end
end
