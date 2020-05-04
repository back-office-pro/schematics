module Schematics
  module Virtuals
    class Concatenation < Virtual
      include Behaviours::Searchable

      def function
        @tokens.map(&:to_str).join.taint.to_json
      end

      def to_sql
        "CONCAT(#{super.join(', ')})"
      end

      def search_field
        :"#{name}_cont"
      end

      def icon
        :align_justify
      end
    end
  end
end
