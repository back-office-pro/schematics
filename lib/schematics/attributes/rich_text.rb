# frozen_string_literal: true

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
          #{name}&.to_plain_text
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
