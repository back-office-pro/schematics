module Schematics
  module Attributes
    class Boolean < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable

      def filter_scope
        super.extends <<~RUBY
          { where(#{@name}: true) }
        RUBY
      end

      def sort_scope
        super.extends <<~RUBY
          sort_direction { order(#{@name}: sort_direction) }
        RUBY
      end

      def has_filter_scope
        super.extends_with_comma <<~RUBY
          type: :boolean
        RUBY
      end

      def icon
        :toggle_on
      end
    end
  end
end
