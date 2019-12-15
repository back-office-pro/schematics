module Schematics
  module Attributes
    class Time < Date
      def format(value)
        I18n.l(value, format: "%H:%M")
      end
    end
  end
end
