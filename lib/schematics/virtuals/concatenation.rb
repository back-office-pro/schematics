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

      def filter_scope
        if joins.empty?
          super.extends <<~RUBY
            #{@name} do
              where("#{to_sql} ILIKE ?", "%#\{#{@name}}%")
            end
          RUBY
        else
          super.extends <<~RUBY
            #{@name} do
              joins(#{joins}).
              where("#{to_sql} ILIKE ?", "%#\{#{@name}}%")
            end
          RUBY
        end
      end
    end
  end
end
