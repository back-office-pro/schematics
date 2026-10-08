# frozen_string_literal: true

module OpenAPI
  module Paths
    class Forward < NestedPath
      protected

      def nested_entity_name = 'emailing'
    end
  end
end
