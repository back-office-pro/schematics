# frozen_string_literal: true

require 'schematics/attributes/attribute'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/preloadable'
require 'schematics/behaviours/fillable'

module Schematics
  module Attributes
    class RichText < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Fillable

      def preload
        [type, name].join('_').to_sym
      end

      def search_data
        <<~RUBY
          #{name}&.to_plain_text&.parameterize(separator: ' ')
        RUBY
      end

      def format(value)
        value&.to_plain_text
      end

      def default
        return 'MyRichText' if required?

        super
      end

      def icon
        :align_justify
      end

      def to_str
        <<~RUBY
          has_rich_text :#{@name}
        RUBY
      end
    end
  end
end
