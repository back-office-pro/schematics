# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module Previewable
    extend ActiveSupport::Concern

    included do
      after_save_commit :generate_link_previews
    end

    def changed_link_preview_urls = self
      .class
      .entity
      .url_attributes
      .map(&:name)
      .select { public_send(:"#{_1}_previously_changed?") }
      .filter_map(&method(:public_send))

    protected

    def generate_link_previews = ::ActiveJob.perform_all_later(
      changed_link_preview_urls.map(&GenerateLinkPreviewJob.method(:new))
    )
  end
end
