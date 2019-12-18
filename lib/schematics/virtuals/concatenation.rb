module Schematics
  module Virtuals
    class Concatenation < Virtual
      def searchable?
        true
      end

      def function
        @tokens.map(&:to_str).join.taint.to_json
      end

      def to_sql
        "CONCAT(#{super.join(', ')})"
      end

      def scope
        if joins.empty?
          super + %Q[#{@name} { where("#{to_sql} ILIKE ?", "%#\{#{@name}}%") }]
        else
          super + %Q[#{@name} { joins(#{joins}).where("#{to_sql} ILIKE ?", "%#\{#{@name}}%") }]
        end
      end
    end
  end
end
