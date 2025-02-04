# frozen_string_literal: true

module OpenAPI
  module Paths
    class Import < NestedPath
      protected

      alias summary_slug tag

      def singleton? = true
    end
  end
end
