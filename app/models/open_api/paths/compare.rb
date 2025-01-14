# frozen_string_literal: true

module OpenAPI
  module Paths
    class Compare < NestedPath
      protected

      def root_path = super.pluralize

      def singleton? = true

      def summary = super.pluralize

      def nested_entity_name = 'comparison'
    end
  end
end
