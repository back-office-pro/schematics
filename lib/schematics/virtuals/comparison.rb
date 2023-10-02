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

      def search_predicate = :eq

      def icon = :toggle_on

      def open_api_type = 'boolean'

      def to_sql = "(#{super.join})"

      def to_str = super.concat(scopes_to_str)

      private

      def scopes_to_str = <<~RUBY
        scope :#{name}, -> { where(Arel.sql("#{to_sql}")) }
        scope :not_#{name}, -> { where.not(Arel.sql("#{to_sql}")) }
      RUBY
    end
  end
end
