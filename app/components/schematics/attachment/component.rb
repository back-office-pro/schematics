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
            replacement: { icon: :circle_user, size: '2x' },
            class: 'align-middle rounded-circle',
            title:
          )
        end

        def company_logo(attachment:, icon:)
          new(attachment:, width: 300, height: 150, replacement: { icon: })
        end
      end

      def initialize(attachment:, width: 300, height: 300, replacement: {}, **kwargs)
        super
        @attachment = attachment
        @width = width
        @height = height
        @replacement = replacement
        @kwargs = kwargs
      end

      def attachment
        @attachment.representation(resize_to_fit: [@width, @height])
      end

      def data = {
        controller: 'tooltip',
        'bs-toggle': 'tooltip',
        'bs-placement': 'top'
      }

      def icon
        @replacement.fetch(:icon, :triangle_exclamation)
      end

      def size
        @replacement.fetch(:size, '7x')
      end
    end
  end
end
