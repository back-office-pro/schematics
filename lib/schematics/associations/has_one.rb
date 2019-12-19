module Schematics
  module Associations
    class HasOne < Association
      def filter_scope
        super + %Q[#{name} { where(#{entity.type}: #{name}) }]
      end

      def sort_scope
        super + %Q[(sort_direction, field) { joins(:#{@entity.type}).merge(#{@entity.type.camelize}.order({ field => sort_direction })) }]
      end
    end
  end
end
