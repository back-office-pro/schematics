# frozen_string_literal: true

module OpenAPI
  module Paths
    class Import < NestedPath
      alias summary_slug tag

      def singleton? = true
    end
  end
end
