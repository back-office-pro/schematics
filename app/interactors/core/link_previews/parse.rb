# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
