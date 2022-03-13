# frozen_string_literal: true

module Schematics
  module Attachment
    class Component < ApplicationComponent
      class << self
        def avatar(user:, title: nil)
          new(
            attachment: user.avatar,
            width: 36,
            height: 36,
            css_class: 'align-middle rounded-circle',
            replacement: { icon: :user_circle, size: '2x' },
            title:
          )
        end

        def company_logo(attachment:, icon:)
          new(attachment:, width: 300, height: 150, replacement: { icon:, size: '7x' })
        end
      end

      # :reek:LongParameterList
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

      def data
        { toggle: 'tooltip', placement: 'top', title: @title }
      end

      def icon
        @replacement[:icon]
      end

      def size
        @replacement[:size]
      end
    end
  end
end
