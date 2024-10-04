# frozen_string_literal: true

module Schematics
  module LinkPreview
    class Component < ApplicationComponent
      option :url

      def favicon
        metadata.fetch(:favicon, File.join(url, 'favicon.ico'))
      end

      def title
        metadata.fetch(:title, url)
      end

      def render?
        url.present?
      end

      private

      def metadata = ::Rails
        .cache
        .fetch("link_preview:#{url}") { {} }
    end
  end
end
