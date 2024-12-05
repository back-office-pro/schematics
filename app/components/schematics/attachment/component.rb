# frozen_string_literal: true

module Schematics
  module Attachment
    class Component < ApplicationComponent
      class << self
        def avatar(user:, width: 32, height: 32, size: :avatar, title: nil)
          new(
            attachment: user.avatar,
            width:,
            height:,
            replacement: { icon: :circle_user, size: },
            class: 'align-middle rounded-circle',
            title:
          )
        end

        def company_logo(icon:)
          new(
            attachment: ::Configuration.with_attached_company_logo.company_logo,
            width: 300,
            height: 150,
            replacement: { icon: }
          )
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

      def data = { controller: 'tooltip' }

      def onerror = <<~JAVASCRIPT.squish
        this.onerror=null;
        this.src="#{image_placeholder_path}";
        this.classList.add('h-25');
      JAVASCRIPT

      def icon
        @replacement.fetch(:icon, :triangle_exclamation)
      end

      def size
        @replacement.fetch(:size, '7x')
      end

      private

      def image_placeholder_path
        asset_path('@fortawesome/fontawesome-free/svgs/solid/triangle-exclamation.svg')
      end
    end
  end
end
