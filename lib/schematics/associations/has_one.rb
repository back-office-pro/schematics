module Schematics
  module Associations
    class HasOne < Association
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
            merge(#{entity.type.camelize}.order(#{descriptor.name}: sort_direction }))
          end
        RUBY
      end
    end
  end
end
