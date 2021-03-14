require 'schematics/attributes/attribute'
require 'schematics/behaviours/listable'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/fillable'

module Schematics
  module Attributes
    class Boolean < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable

      def icon
        :toggle_on
      end

      protected

      def migration_options
        super.concat %i[default]
      end
    end
  end
end
