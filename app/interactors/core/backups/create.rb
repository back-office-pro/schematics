# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Core
  module Backups
    class Create
      include Interactor

      delegate :root, :env, :configuration, to: '::Rails', private: true
      delegate :database_configuration, to: :configuration, private: true
      delegate :create_and_upload!, to: '::ActiveStorage::Blob', private: true
      delegate :current_database,
               :adapter_name,
               to: 'ActiveRecord::Base.lease_connection',
               private: true

      def call
        IO.popen(command.compact.join(' ')) do |io|
          context.file = create_and_upload!(key:, filename:, content_type:, io: file(io.read))
        end
      end

      private

      def command
        case adapter_name
        when 'SQLite'
          ["sqlite3 #{db_path} '.dump #{tables.join(' ')}' | gzip -c"]
        when 'PostgreSQL'
          ['pg_dump -Fc', ('-a' if tables.any?), tables.map { "-t #{_1}" }, current_database]
        end
      end

      def db_path = root.join(database_configuration.dig(env, 'database'))

      def tables = Array(context.tables)

      def key = File.join(
        'backups',
        Time.current.strftime('%Y_%m_%d_%H_%M_%S_%L'),
        filename
      )

      def filename = 'db.dump'

      def content_type = 'application/octet-stream'

      def file(content)
        Tempfile
          .new
          .tap { _1.write(content) }
          .tap(&:rewind)
      end
    end
  end
end
