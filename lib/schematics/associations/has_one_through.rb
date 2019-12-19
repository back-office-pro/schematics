module Schematics
  module Associations
    class HasOneThrough < AssociationThrough
      def name
        reference.name
      end

      def class_name
        name.camelize
      end

      def filter_scope
        super + %Q[#{name} { joins(:#{entity.type}).where(#{name}: #{name}) }]
      end
      
      def sort_scope
        super + %Q[sort_direction { joins(:#{entity.type}, :#{name}).merge(#{name.camelize}.order(#{descriptor.name}: sort_direction)) }]
      end
    end
  end
end
