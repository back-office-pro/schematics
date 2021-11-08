# frozen_string_literal: true

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
          #{name}&.to_s
        RUBY
      end
    end
  end
end
