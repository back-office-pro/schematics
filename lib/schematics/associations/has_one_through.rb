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

      def descriptor
        @belongs_to.inverse_descriptor
      end

      def joins
        [entity.type.to_sym]
      end

      def filter_scope
        super.extends <<~RUBY
          #{name} { joins(#{joins}).where(#{name}: #{name}) }
        RUBY
      end

      def sort_scope
        super.extends <<~RUBY
          sort_direction do
            joins(#{joins + includes}).
            merge(#{class_name}.order(Arel.sql("#{descriptor.to_sql}") => sort_direction))
          end
        RUBY
      end
    end
  end
end
