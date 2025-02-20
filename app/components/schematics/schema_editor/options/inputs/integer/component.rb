# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Inputs
        module Integer
          class Component < Inputs::Component
            delegate :min, to: :option
          end
        end
      end
    end
  end
end
