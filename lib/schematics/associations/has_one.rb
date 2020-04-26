module Schematics
  module Associations
    class HasOne < Association
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Preloadable

      def filter_scope
        super.extends <<~RUBY
          #{name} { where(#{entity.type}: #{name}) }
        RUBY
      end

      def joins
        entity.type.to_sym
      end

      def sort_scope
        super.extends <<~RUBY
          sort_direction do
            joins(:#{joins}).
            merge(#{class_name}.order(Arel.sql("#{descriptor.to_sql}") => sort_direction))
          end
        RUBY
      end
    end
  end
end
