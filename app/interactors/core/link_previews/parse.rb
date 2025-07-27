# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module LinkPreviews
    class Parse
      include Interactor

      delegate :url, to: :context, private: true
      delegate :css, to: :document, private: true

      def call
        context.title = title&.to_s
        context.description = description&.to_s
        context.image = image&.to_s
      end

      private

      memoize def file = ::URI
        .parse(url)
        .open(open_timeout: 5, read_timeout: 5)

      memoize def document = ::Nokogiri::HTML(file)

      def title
        css('meta[property="og:title"]').attribute('content') ||
          css('title').text
      end

      def description
        css('meta[property="og:description"]').attribute('content') ||
          css('meta[name="description"]').attribute('content')
      end

      def image
        css('meta[property="og:image"]').attribute('content')
      end
    end
  end
end
