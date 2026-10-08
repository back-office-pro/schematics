# frozen_string_literal: true

module Schematics
  module LinkPreview
    class Component < ApplicationComponent
      delegate :image, :title, to: :link_preview
      option :url

      def data = {
        controller: 'popover',
        'bs-trigger': 'hover',
        'bs-content': __link_preview_popover(link_preview:),
        'bs-placement': 'bottom',
        'bs-html': true
      }

      def render?
        url.present?
      end

      private

      memoize def link_preview = ::LinkPreview.find_or_initialize_by(url:)
    end
  end
end
