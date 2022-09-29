# frozen_string_literal: true

module Schematics
  module Resources
    class GenerateFile
      include Interactor
      include Rails.application.routes.url_helpers

      delegate :user, :serializer, :dropdown, :component_method, to: :context, private: true
      delegate :file, :filename, :extension, :content_type, to: :serializer, private: true

      def call
        ::ActiveStorage::PurgeJob
          .set(wait: 5.minutes)
          .perform_later(blob)
        ::Turbo::StreamsChannel.broadcast_replace_to(
          user,
          target: 'generate_file_in_background',
          content: Button::GenerateFileInBackground::Component
            .public_send(component_method || extension, dropdown:, url:)
            .to_html
        )
      end

      private

      def blob
        @blob ||= ::ActiveStorage::Blob.create_and_upload!(io: file, filename:, content_type:)
      end

      def url = url_for(blob)
    end
  end
end
