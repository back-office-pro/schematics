# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Address
        class Component < Fields::Component
          delegate :gcloud_public_api_key, to: '::Configuration', private: true

          def collection = [value, (name if Rails.env.test?)].compact

          def prompt
            return t('.missing_key') unless gcloud_public_api_key

            t('prompt', attribute_name: attribute_name.downcase)
          end

          def autocomplete = 'new-address'

          def data = { controller: 'dropdowns--address-autocomplete-dropdown' }
        end
      end
    end
  end
end
