# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Options
      module Events
        class Component < ApplicationComponent
          delegate :events, to: '@builder.object'
          renders_one_form :builder

          def initialize(builder:)
            super
            @builder = builder
          end
        end
      end
    end
  end
end
