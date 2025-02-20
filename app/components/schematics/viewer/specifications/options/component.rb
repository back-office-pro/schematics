# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Viewer
    module Specifications
      module Options
        class Component < Section::Component
          delegate :human_attribute_name, to: 'Schematics::Options::Wrapper'
        end
      end
    end
  end
end
