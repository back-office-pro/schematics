# frozen_string_literal: true

require 'arel'

module Schematics
  module Virtuals
    class Concatenation < Virtual
      include Behaviours::Multisearchable

      def icon = :align_justify

      def to_sql
        ::Arel.sql("CONCAT(#{super.join(', ')})")
      end

      protected

      def method_body = tokens
        .map(&:to_str)
        .join
        .to_json
    end
  end
end
