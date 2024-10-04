# frozen_string_literal: true

module Schematics
  module LinkPreviews
    class Create
      include Interactable
      delegate :url, to: :context, private: true
      delegate :css, to: :document, private: true

      def call = ::Rails
        .cache
        .write(cache_key, metadata.compact_blank)

      private

      memoize def file = ::URI
        .parse(url)
        .open(open_timeout: 5, read_timeout: 5)

      memoize def document = ::Nokogiri::HTML(file)

      def cache_key = "link_preview:#{url}"

      def metadata = {
        title: css('title').text,
        favicon: css('link[rel="icon"]').first.try(:[], 'href')
      }
    end
  end
end
