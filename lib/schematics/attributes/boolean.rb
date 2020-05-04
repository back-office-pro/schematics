module Schematics
  module Attributes
    class Boolean < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Fillable

      def search_field
        :"#{name}_true"
      end

      def icon
        :toggle_on
      end
    end
  end
end
