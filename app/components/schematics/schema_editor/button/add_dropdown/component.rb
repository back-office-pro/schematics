# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module AddDropdown
        class Component < ApplicationComponent
          delegate :index, to: :@builder

          def initialize(builder:)
            super
            @builder = builder
          end
        end
      end
    end
  end
end
