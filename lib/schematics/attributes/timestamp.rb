# frozen_string_literal: true

module Schematics
  module Attributes
    class Timestamp < Attribute
      include Behaviours::Renderable
      include Behaviours::Rangeable

      def format(value)
        value && localize(value, format: '%A %d %B %Y %H:%M')
      end

      def icon
        :calendar_alt
      end
    end
  end
end
