# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Address
        class Component < Fields::Component
          def collection = [value, (name if Rails.env.test?)].compact

          def prompt = t('prompt', attribute_name: attribute_name.downcase)

          def autocomplete = 'new-address'

          def data = { controller: 'dropdowns--address-autocomplete-dropdown' }
        end
      end
    end
  end
end
