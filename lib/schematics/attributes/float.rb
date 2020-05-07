module Schematics
  module Attributes
    class Float < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable

      def validators
        super.merge(numericality: { allow_nil: !required? })
      end

      def unit
        @options[:unit]
      end

      def format(value)
        value && [value, unit].compact.join(' ')
      end

      def icon
        :sort_numeric_up
      end
    end
  end
end
