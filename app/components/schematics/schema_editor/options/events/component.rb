# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Events
        class Component < ApplicationComponent
          renders_one_form :builder

          def initialize(builder:)
            super
            @builder = builder
          end

          def events
            @builder.object.events || []
          end
        end
      end
    end
  end
end
