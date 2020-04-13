module Schematics
  module Attributes
    class Datetime < Date
      def format(value)
        value && I18n.l(value, format: "%A %d %B %Y %H:%M")
      end
    end
  end
end
