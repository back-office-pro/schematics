# frozen_string_literal: true

module Core
  module Backups
    class Create
      include Interactor

      delegate :current_database, to: 'ActiveRecord::Base.lease_connection', private: true
      delegate :create_and_upload!, to: ::ActiveStorage::Blob, private: true
      delegate :tables, to: :context, private: true

      def call
        IO.popen(command) do |io|
          context.file = create_and_upload!(key:, filename:, content_type:, io: file(io.read))
        end
      end

      private

      def command = [
        'pg_dump',
        '-Fc',
        ('-a' if table_options.any?),
        table_options,
        current_database
      ].flatten.compact.join(' ')

      def table_options
        Array(tables).map { "-t #{_1}" }
      end

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
