# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Trigger
        class Component < Template::Component
          def trigger = Triggers::Trigger.new(id: 'RANDOM_UUID', entity:)
        end
      end
    end
  end
end
