# frozen_string_literal: true

module Schematics
  module Virtuals
    class Comparison < Virtual
      # :reek:NilCheck
      def format(value)
        case value
        when nil, StandardError
          super
        else
          translate(value, default: value.to_s).upcase
        end
      end

      def search_predicate = :true

      def icon = :toggle_on

      def open_api_schema_type = 'boolean'

      def to_str = super.concat(scopes_to_str)

      def allowed_variables = entity
        .specifiable_elements
        .map(&:name)

      private

      def scopes_to_str = <<~RUBY
        scope :#{name}, -> { where(Arel.sql("#{to_sql}")) }
        scope :not_#{name}, -> { where.not(Arel.sql("#{to_sql}")) }
      RUBY
    end
  end
end
