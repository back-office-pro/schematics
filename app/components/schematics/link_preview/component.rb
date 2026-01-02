# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
