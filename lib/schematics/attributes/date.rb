module Schematics
  module Attributes
    class Date < Attribute
      include Behaviours::Renderable
      include Behaviours::Filterable
      include Behaviours::Sortable
      include Behaviours::Range::Filterable
      include Behaviours::Default::Sortable

      def format(value)
        value && I18n.l(value, format: "%A %d %B %Y")
      end

      def icon
        :calendar_alt
      end
    end
  end
end
