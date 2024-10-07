# frozen_string_literal: true

module Core
  module LinkPreviews
    class Upsert
      include Schematics::Interactable
      delegate :url, :title, :description, :image, to: :context, private: true

      def call
        fail! unless link_preview.update(title:, description:, image: blob)
      end

      private

      memoize def io = ::URI
        .parse(image)
        .open(open_timeout: 5, read_timeout: 5)

      memoize def blob
        ::ActiveStorage::Blob.create_and_upload!(io:, filename:) if image
      end

      memoize def link_preview
        ::LinkPreview.find_or_initialize_by(url:)
      end

      def filename
        File.basename(URI.parse(image).path)
      end
    end
  end
end
