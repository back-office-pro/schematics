# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Virtual
        class Component < Template::Component
          def virtual = Virtuals::Calculation.new(id: 'RANDOM_UUID', entity:)
        end
      end
    end
  end
end
