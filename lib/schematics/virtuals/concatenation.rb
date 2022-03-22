# frozen_string_literal: true

module Schematics
  module Virtuals
    class Concatenation < Virtual
      def function
        tokens.map(&:to_str).join.to_json
      end

      def to_sql
        "CONCAT(#{super.join(', ')})"
      end

      def search_data
        super
          .concat(' ')
          .concat <<~RUBY
            #{name}&.to_s
          RUBY
      end

      def icon
        :align_justify
      end
    end
  end
end
