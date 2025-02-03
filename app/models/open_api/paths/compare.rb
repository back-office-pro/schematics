# frozen_string_literal: true

module OpenAPI
  module Paths
    class Compare < NestedPath
      protected

      alias summary_slug tag

      def singleton? = true

      def nested_entity_name = 'comparison'
    end
  end
end
