# frozen_string_literal: true

module Schematics
  module Attributes
    class Model < String
      def format(value)
        return unless value
        return unless Object.const_defined?(value)

        value.constantize.model_name.human
      end

      def icon
        :project_diagram
      end
    end
  end
end
