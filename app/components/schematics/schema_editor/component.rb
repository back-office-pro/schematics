# frozen_string_literal: true

module Schematics
  module SchemaEditor
    class Component < ApplicationComponent
      prepend ViewComponent::GlobalOutputBuffer

      def entities
        Schema
          .instance
          .entities
          .reject(&:core?)
          .select { Object.const_defined?(_1.class_name) }
          .sort_by { _1.model_class.human_name }
      end
    end
  end
end
