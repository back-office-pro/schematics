# frozen_string_literal: true

module Schematics
  module SchemaDatasets
    class Backup
      include Interactor
      delegate :create_and_upload!, to: 'ActiveStorage::Blob', private: true
      delegate :needs_migration?, to: :migration_context, private: true
      delegate :force, to: :context, private: true
      delegate :current_database,
               :migration_context,
               to: 'ActiveRecord::Base.connection',
               private: true

      def call
        return unless needs_migration? || force

        IO.popen("pg_dump -Fc #{current_database}") do |io|
          create_and_upload!(key:, io: file(io.read), filename:, content_type:)
        end
      end

      private

      def content_type = 'application/octet-stream'

      def file(content)
        file = Tempfile.new(filename)
        file.write(content)
        file.rewind
        file
      end

      def filename = 'db.dump'

      def key = File.join('backups', ::Time.current.to_s)
    end
  end
end
