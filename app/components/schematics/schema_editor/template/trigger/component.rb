# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Template
      module Trigger
        class Component < Template::Component
          def trigger = Schematics::Trigger.new
        end
      end
    end
  end
end
