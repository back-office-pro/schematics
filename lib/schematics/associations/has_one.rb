module Schematics
  module Associations
    class HasOne < Association
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      def search_field
        :"#{name}_#{descriptor.name}"
      end
    end
  end
end
