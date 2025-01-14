# frozen_string_literal: true

module OpenAPI
  module Paths
    class Import < NestedPath
      protected

      def root_path = super.pluralize

      def singleton? = true

      def summary = super.pluralize
    end
  end
end
