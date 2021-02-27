require 'schematics/virtuals/virtual'

module Schematics
  module Virtuals
    class Concatenation < Virtual
      def function
        @tokens.map(&:to_str).join.to_json
      end

      def to_sql
        "CONCAT(#{super.join(', ')})"
      end

      def search_data
        <<~RUBY
          #{name}&.searchize
        RUBY
      end

      def icon
        :align_justify
      end
    end
  end
end
