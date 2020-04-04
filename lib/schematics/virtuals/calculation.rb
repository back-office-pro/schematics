module Schematics
  module Virtuals
    class Calculation < Virtual
      def to_sql
        super.join
      end

      def filter_scope
        if joins.empty?
          super.extends <<~RUBY
            (from, to) do
              return where("#{to_sql} <= ?", to) if from.nil?
              return where("#{to_sql} >= ?", from) if to.nil?
              return where("#{to_sql} >= ? AND #{to_sql} <= ?", from, to)
            end
          RUBY
        else
          super.extends <<~RUBY
            (from, to) do
              return joins(#{joins}).where("#{to_sql} <= ?", to) if from.nil?
              return joins(#{joins}).where("#{to_sql} >= ?", from) if to.nil?
              return joins(#{joins}).where("#{to_sql} >= ? AND #{to_sql} <= ?", from, to)
            end
          RUBY
        end
      end

      def has_filter_scope
        super.extends_with_comma <<~RUBY
          using: [:from, :to]
        RUBY
      end

      def unit
        @options[:unit]
      end

      def scale
        @options[:scale]
      end

      def format(value)
        [scale.nil? ? value : value.round(scale), unit].compact.join(' ')
      end

      def icon
        :square_root_alt
      end
    end
  end
end
