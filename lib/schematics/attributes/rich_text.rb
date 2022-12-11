# frozen_string_literal: true

module Schematics
  module Attributes
    class RichText < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Preloadable
      include Behaviours::Fillable
      include Behaviours::Encryptable

      def default = 'MyRichText'

      def encrypted? = true

      def format(value)
        value&.to_plain_text
      end

      def icon = :align_justify

      def preload = {
        association_name => [embeds_attachments: :blob]
      }

      def search_column = :"rich_text_#{name}_body"

      def to_str = <<~RUBY
        has_rich_text :#{name}, encrypted: true
      RUBY

      private

      def association_name = [type, name]
        .join('_')
        .to_sym
    end
  end
end
