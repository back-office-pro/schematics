# frozen_string_literal: true

module Schematics
  module Attachment
    class Component < ApplicationComponent
      class << self
        def build_avatar(user:, title: true, css_class: 'rounded-circle')
          new(
            attachment: user.avatar,
            width: 36,
            height: 36,
            css_class:,
            replacement: { icon: :user_circle, size: '2x' },
            title: (user.full_name if title)
          )
        end

        def build_company_logo(attachment:, icon:)
          new(attachment:, width: 300, height: 150, replacement: { icon:, size: '7x' })
        end
      end

      def initialize( # rubocop:disable Metrics/ParameterLists
        attachment:,
        width: 800,
        height: 600,
        replacement: nil,
        css_class: nil,
        title: nil
      )
        super
        @attachment = attachment
        @width = width
        @height = height
        @replacement = replacement
        @css_class = css_class
        @title = title
      end

      def attachment
        @attachment
          .representation(resize_to_fit: [@width, @height])
          .processed
      end
    end
  end
end
