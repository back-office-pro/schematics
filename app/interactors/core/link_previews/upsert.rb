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

module Core
  module LinkPreviews
    class Upsert
      include Interactor

      delegate :url, :title, :description, :image, to: :context, private: true

      def call = ::LinkPreview
        .find_or_initialize_by(url:)
        .update!(title:, description:, image: blob)

      private

      memoize def io = ::URI
        .parse(image)
        .open(open_timeout: 5, read_timeout: 5)

      memoize def blob
        ::ActiveStorage::Blob.create_and_upload!(io:, filename:) if image
      end

      def filename
        File.basename(URI.parse(image).path)
      end
    end
  end
end
