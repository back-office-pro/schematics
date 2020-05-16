module Schematics
  module Filters
    class CheckboxCell < FilterCell
      def active?
        value == "true"
      end
    end
  end
end
