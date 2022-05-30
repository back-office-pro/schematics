# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Button
      module Remove
        class Component < ApplicationComponent
          def initialize(wrapper:)
            super
            @wrapper = wrapper
          end
        end
      end
    end
  end
end
