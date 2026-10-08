# frozen_string_literal: true

module Core
  module Migrations
    class GenerateFixture
      include Interactor

      delegate :current_data, to: '::Migration', private: true

      def call
        ::ActiveStorage::Blob.find_by(key:).try(:purge)
        ::ActiveStorage::Blob.create_and_upload!(key:, filename:, content_type:, io:)
      end

      private

      def key = File.join('backups', filename)

      def filename = 'migration.json'

      def content_type = ::Mime[:json].to_s

      def io = Tempfile
        .new
        .tap { it.write(current_data.to_json) }
        .tap(&:rewind)
    end
  end
end
