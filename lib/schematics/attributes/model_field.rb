# frozen_string_literal: true

module Schematics
  module Attributes
    class ModelField < String
      include Behaviours::Enumerable

      def values
        fields
          .map(&:name)
          .uniq
      end

      def input_collection
        fields
          .map { [_1.name, _1.entity.class_name.constantize.human_attribute_name(_1.name)] }
          .tap { _1.unshift ['', ''] unless required? }
          .sort_by(&input_collection_sort_by_key)
      end

      def icon
        :code
      end

      private

      def fields
        Schema
          .instance
          .entities
          .flat_map(&:renderable_fields)
      end
    end
  end
end
