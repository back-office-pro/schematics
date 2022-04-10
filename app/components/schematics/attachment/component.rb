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
            replacement: { icon: :user_circle, size: '2x' },
            class: 'align-middle rounded-circle',
            title:
          )
        end

        def company_logo(attachment:, icon:)
          new(attachment:, width: 300, height: 150, replacement: { icon:, size: '7x' })
        end
      end

      def initialize(attachment:, width: 300, height: 300, replacement: nil, **kwargs)
        super
        @attachment = attachment
        @width = width
        @height = height
        @replacement = replacement
        @kwargs = kwargs
      end

      def attachment
        @attachment
          .representation(resize_to_fit: [@width, @height])
          .processed
      end

      def data
        { controller: 'tooltip', 'bs-toggle': 'tooltip', 'bs-placement': 'top' }
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
