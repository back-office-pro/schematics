# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Virtual
      class Component < ApplicationComponent
        renders_one_form :builder

        def initialize(builder:)
          super
          @builder = builder
        end

        def icon
          @builder.object.try(:icon) || :plus
        end
      end
    end
  end
end
