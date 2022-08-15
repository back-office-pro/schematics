# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Virtual
      class Component < ApplicationComponent
        delegate :icon, to: '@builder.object'
        renders_one_form :builder

        def initialize(builder:)
          super
          @builder = builder
        end
      end
    end
  end
end
