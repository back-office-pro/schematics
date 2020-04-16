module Schematics
  module Associations
    class HasOneThrough < AssociationThrough
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Preloadable

      def name
        belongs_to.name
      end

      def class_name
        name.camelize
      end

      def filter_scope
        super.extends <<~RUBY
          #{name} { joins(:#{entity.type}).where(#{name}: #{name}) }
        RUBY
      end

      def sort_scope
        super.extends <<~RUBY
          sort_direction do
            joins(:#{entity.type}, :#{joins}).
            merge(#{class_name}.order(#{descriptor.name}: sort_direction))
          end
        RUBY
      end
    end
  end
end
