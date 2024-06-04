# frozen_string_literal: true

module Core
  module Migrations
    class Backup
      include Interactor

      delegate :migration_context, to: 'ActiveRecord::Base.connection_pool', private: true
      delegate :current_database, to: 'ActiveRecord::Base.lease_connection', private: true
      delegate :table_name, to: ::SolidCache::Entry, prefix: :solid_cache, private: true
      delegate :create_and_upload!, to: ::ActiveStorage::Blob, private: true
      delegate :needs_migration?, to: :migration_context, private: true
      delegate :force, to: :context, private: true

      def call
        return unless needs_migration? || force

        IO.popen(command) do |io|
          create_and_upload!(key:, io: file(io.read), filename:, content_type:)
        end
      end

      private

      def command = "pg_dump -Fc #{current_database} --exclude-table-data=#{solid_cache_table_name}"

      def content_type = 'application/octet-stream'

      def file(content)
        file = Tempfile.new
        file.write(content)
        file.rewind
        file
      end

      def filename = 'db.dump'

      def key = File.join('backups', ::Time.current.strftime('%Y_%m_%d_%H_%M_%S_%L'), filename)
    end
  end
end
