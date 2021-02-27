require 'schematics/associations/association_through'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/preloadable'
require 'active_support/core_ext/module/delegation'

module Schematics
  module Associations
    class HasOneThrough < AssociationThrough
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      delegate :name, to: :belongs_to

      def class_name
        name.camelize
      end

      def descriptor
        belongs_to.inverse_descriptor
      end

      def search_data
        <<~RUBY
          #{name}&.#{descriptor.name}&.searchize
        RUBY
      end
    end
  end
end
