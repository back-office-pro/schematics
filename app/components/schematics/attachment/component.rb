# frozen_string_literal: true

module Schematics
  module Attachment
    class Component < ApplicationComponent
      class << self
        def create_avatar(attachment:)
          new(
            attachment:,
            width: 36,
            height: 36,
            css_class: 'rounded-circle',
            replacement: { icon: :user_circle, size: '2x' }
          )
        end

        def create_company_logo(attachment:, icon:)
          new(attachment:, width: 300, height: 150, replacement: { icon:, size: '7x' })
        end
      end

      def initialize(attachment:, width: 800, height: 600, replacement: nil, css_class: nil)
        super
        @attachment = attachment
        @width = width
        @height = height
        @replacement = replacement
        @css_class = css_class
      end

      def attachment
        @attachment
          .representation(resize_to_fit: [@width, @height])
          .processed
      end
    end
  end
end
