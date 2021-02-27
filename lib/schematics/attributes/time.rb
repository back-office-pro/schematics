require 'schematics/attributes/datetime'

module Schematics
  module Attributes
    class Time < Datetime
      def format(value)
        value && I18n.l(value, format: '%H:%M')
      end

      def icon
        :clock
      end
    end
  end
end
