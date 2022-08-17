# frozen_string_literal: true

module Schematics
  module SchemaEditor
    module Attribute
      class Component < ApplicationComponent
        delegate :icon, :type, to: '@builder.object'
        renders_one_form :builder

        def initialize(builder:)
          super
          @builder = builder
        end

        def title = Attributes
          .const_get(type.camelize.to_sym)
          .model_name
          .human
      end
    end
  end
end
