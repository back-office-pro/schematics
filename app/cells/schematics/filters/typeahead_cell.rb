module Schematics
  module Filters
    class TypeaheadCell < FilterCell
      def id
        name.camelize(:lower)
      end
    end
  end
end
