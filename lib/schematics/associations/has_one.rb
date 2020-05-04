module Schematics
  module Associations
    class HasOne < Association
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Preloadable

      def search_field
        :"#{name}_#{descriptor.name}_cont"
      end

      def sort_field
        :"#{name}_#{descriptor.name}"
      end
    end
  end
end
