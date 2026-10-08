# frozen_string_literal: true

require 'arel'

module Schematics
  module Virtuals
    class Concatenation < Virtual
      include Behaviours::Multisearchable

      def icon = :align_justify

      def allowed_variables = entity
        .renderable_elements
        .map(&:name)

      private

      def method_body = %("#{tokens.map(&:to_str).join}")

      def to_sql_separator = ' || '
    end
  end
end
