module Schematics
  module Associations
    class HasOneThrough < AssociationThrough
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      def name
        belongs_to.name
      end

      def class_name
        name.camelize
      end

      def descriptor
        @belongs_to.inverse_descriptor
      end

      def search_data
        <<~RUBY
          #{name}&.#{descriptor.name}&.searchize
        RUBY
      end
    end
  end
end
