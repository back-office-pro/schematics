module Schematics
  module Associations
    class HasOne < Association
      def filter_scope
        super + %Q[#{name} { where(#{entity.type}: #{name}) }]
      end

      def sort_scope
        super + %Q[sort_direction { joins(:#{@entity.type}).merge(#{@entity.type.camelize}.order(#{entity.descriptor.name}: sort_direction })) }]
      end
    end
  end
end
