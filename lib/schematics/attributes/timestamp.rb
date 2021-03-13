require 'schematics/attributes/attribute'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/rangeable'

module Schematics
  module Attributes
    class Timestamp < Attribute
      include Behaviours::Renderable
      include Behaviours::Rangeable

      def format(value)
        value && I18n.l(value, format: '%A %d %B %Y %H:%M')
      end

      def icon
        :calendar_alt
      end
    end
  end
end
