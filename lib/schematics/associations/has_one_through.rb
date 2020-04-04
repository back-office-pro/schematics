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
        super.extends <<~RUBY
          #{name} { joins(:#{entity.type}).where(#{name}: #{name}) }
        RUBY
      end

      def sort_scope
        super.extends <<~RUBY
          sort_direction do
            joins(:#{entity.type}, :#{name}).
            merge(#{name.camelize}.order(#{descriptor.name}: sort_direction))
          end
        RUBY
      end
    end
  end
end
