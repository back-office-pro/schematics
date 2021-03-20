require 'schematics/associations/association'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/preloadable'

module Schematics
  module Associations
    class HasOne < Association
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      def to_str
        super
          .chomp
          .concat(', ')
          .concat <<~RUBY
            inverse_of: :#{inverse_of}
          RUBY
      end

      def search_data
        <<~RUBY
          #{name}&.#{descriptor.name}&.searchize
        RUBY
      end
    end
  end
end
