module Schematics
  module Filters
    class DropdownCell < FilterCell
      include ActionView::Helpers::FormOptionsHelper
      property :input_collection

      def collection
        input_collection.map(&:reverse)
      end
    end
  end
end
