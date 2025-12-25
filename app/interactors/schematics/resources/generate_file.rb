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
  module Resources
    class GenerateFile
      include Interactor

      PURGE_WAIT = 5.minutes.freeze

      delegate :user, :serializer, :dropdown, :component_method, to: :context, private: true
      delegate :file, :filename, :extension, :content_type, to: :serializer, private: true

      def call
        ::ActiveStorage::PurgeJob
          .set(wait: PURGE_WAIT)
          .perform_later(blob)
        ::Turbo::StreamsChannel.broadcast_replace_to(
          user,
          :generate_file_in_background,
          target: 'generate_file_in_background',
          renderable:
        )
      end

      private

      memoize def blob
        ::ActiveStorage::Blob.create_and_upload!(io: file, filename:, content_type:)
      end

      def renderable = Button::GenerateFileInBackground::Component
        .public_send(component_method || extension, dropdown:, url:)

      def url = ::Rails
        .application
        .routes
        .url_helpers
        .rails_blob_path(blob, host: 'localhost', disposition: 'attachment')
    end
  end
end
