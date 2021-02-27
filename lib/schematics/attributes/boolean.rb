require 'schematics/attributes/attribute'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/fillable'

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
