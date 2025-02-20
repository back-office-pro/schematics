# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Filter
    module Checkbox
      class Component < Filter::Component
        def active?
          value == 'true'
        end

        def css_class
          'w-0' if label.blank?
        end

        def label
          t(".#{name}", default: '')
        end
      end
    end
  end
end
