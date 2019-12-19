module Schematics
  module Attributes
    class Text < Attribute
      def migration_options
        super + [:limit]
      end

      def filter_scope
        super + %Q[#{@name} { where("#{@entity.type.pluralize}.#{@name} ILIKE ?", "%#\{#{@name}}%") }]
      end

      def sort_scope
        super + %Q[sort_direction { order(#{@name}: sort_direction) }]
      end

      def searchable?
        true
      end
    end
  end
end
