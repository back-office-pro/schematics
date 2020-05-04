module Schematics
  module Attributes
    class Float < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Fillable

      def validators
        super.merge(numericality: { allow_nil: !required? })
      end

      def unit
        @options[:unit]
      end

      def search_field
        [:"#{name}_gteq", :"#{name}_lteq"]
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
