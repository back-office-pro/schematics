# frozen_string_literal: true

module Schematics
  module Input
    module Array
      class Component < ApplicationComponent
        delegate :object, to: :builder, private: true
        renders_one_form :builder
        option :builder
        option :object_name
        option :attribute_name
        option :merged_input_options

        def name = "#{object_name}[#{attribute_name}][]"

        def values = Array(object.public_send(attribute_name))
      end
    end
  end
end
