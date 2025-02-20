# Copyright © 2025 Dev & Software. All rights reserved.
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
