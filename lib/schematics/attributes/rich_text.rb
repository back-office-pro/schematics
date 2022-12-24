# frozen_string_literal: true

module Schematics
  module Attributes
    class RichText < Attribute
      include Behaviours::Renderable
      include Behaviours::Multisearchable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Fillable

      def default = 'MyRichText'

      def format(value)
        value&.to_plain_text
      end

      def icon = :align_justify

      def preload = {
        association_name => [embeds_attachments: :blob]
      }

      def search_column = :"rich_text_#{name}_body"

      def to_sql = 'action_text_rich_texts.body'

      def to_str = <<~RUBY
        has_rich_text :#{name}
      RUBY

      private

      def association_name = [type, name]
        .join('_')
        .to_sym
    end
  end
end
