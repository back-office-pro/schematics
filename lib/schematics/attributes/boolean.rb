module Schematics
  module Attributes
    class Boolean < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable

      def icon
        :toggle_on
      end
    end
  end
end
