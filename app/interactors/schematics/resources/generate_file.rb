# frozen_string_literal: true

module Schematics
  module Resources
    class GenerateFile
      include Interactor
      include Rails.application.routes.url_helpers
      delegate :file, :filename, to: :@serializer

      before do
        @user = context.user
        @serializer = context.serializer
        @filename = context.filename
        @extension = context.extension
        @component_method = context.component_method || @extension
        @dropdown = context.dropdown
      end

      def call
        ::ActiveStorage::PurgeJob
          .set(wait: 5.minutes)
          .perform_later(blob)
        ::Turbo::StreamsChannel.broadcast_replace_to(
          @user,
          target: 'generate_file_in_background',
          content: Button::GenerateFileInBackground::Component
            .public_send(@component_method, dropdown: @dropdown, url: url_for(blob))
            .to_html
        )
      end

      private

      def blob
        @blob ||= ::ActiveStorage::Blob.create_and_upload!(io: file, filename:, content_type:)
      end

      def content_type
        ::Mime[@extension].to_s
      end
    end
  end
end
