# Copyright © 2025 Dev & Software. All rights reserved.
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
