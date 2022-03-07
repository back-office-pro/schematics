# frozen_string_literal: true

require 'active_support/core_ext/string/indent'

module Schematics
  module Associations
    class HasOne < Association
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable

      def to_str
        super
          .chomp
          .concat(",\n")
          .concat <<~RUBY.indent(8)
            inverse_of: :#{inverse_of},
            autosave: true
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
