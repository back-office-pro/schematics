module Schematics
  module Attributes
    class Text < Attribute
      def migration_options
        super + [:limit]
      end

      def filter_scope
        super.extends <<~RUBY
          #{@name} { where("#{@entity.type.pluralize}.#{@name} ILIKE ?", "%#\{#{@name}}%") }
        RUBY
      end

      def sort_scope
        super.extends <<~RUBY
          sort_direction { order(#{@name}: sort_direction) }
        RUBY
      end

      def searchable?
        true
      end
    end
  end
end
