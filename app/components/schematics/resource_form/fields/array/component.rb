# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Array
        class Component < Fields::Component
          def collection = [value, (name if Rails.env.test?)].compact

          def prompt
            t('prompt', attribute_name: attribute_name.downcase.singularize(I18n.locale))
          end

          def data = { controller: 'dropdown', 'dropdown-create-value': true }
        end
      end
    end
  end
end
