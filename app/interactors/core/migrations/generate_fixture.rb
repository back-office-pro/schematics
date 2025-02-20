# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Migrations
    class GenerateFixture
      include Schematics::Progressable
      delegate :migration, to: :context, private: true

      progressable migration: 90

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
        .tap { it.write(migration.data.to_json) }
        .tap(&:rewind)
    end
  end
end
