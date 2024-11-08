# frozen_string_literal: true

require 'arel'

module Schematics
  module Virtuals
    class Concatenation < Virtual
      include Behaviours::Multisearchable

      def icon = :align_justify

      def to_sql = "CONCAT(#{super.join(', ')})"

      def allowed_variables = entity
        .renderable_elements
        .map(&:name)

      private

      def method_body = tokens
        .map(&:to_str)
        .join
        .to_json
    end
  end
end
