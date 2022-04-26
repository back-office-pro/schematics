# frozen_string_literal: true

module Schematics
  module Attributes
    class RichText < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Fillable

      def preload
        { association_name => [embeds_attachments: :blob] }
      end

      def search_data
        super
          .concat(' ')
          .concat <<~RUBY
            #{name}&.to_plain_text
          RUBY
      end

      def format(value)
        value&.to_plain_text
      end

      def default
        'MyRichText'
      end

      def icon
        :align_justify
      end

      def to_str
        <<~RUBY
          has_rich_text :#{name}
        RUBY
      end

      private

      def association_name
        [type, name].join('_').to_sym
      end
    end
  end
end
