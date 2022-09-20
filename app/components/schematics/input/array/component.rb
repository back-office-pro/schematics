# frozen_string_literal: true

module Schematics
  module Input
    module Array
      class Component < ApplicationComponent
        delegate :object, to: :@builder, private: true
        renders_one_form :builder

        def initialize(builder:, object_name:, attribute_name:, merged_input_options:)
          super
          @builder = builder
          @object_name = object_name
          @attribute_name = attribute_name
          @merged_input_options = merged_input_options
        end

        def name = "#{@object_name}[#{@attribute_name}][]"

        def values = Array(object.public_send(@attribute_name))
      end
    end
  end
end
