# frozen_string_literal: true

module Core
  module Backups
    class Create
      delegate :current_database, to: 'ActiveRecord::Base.lease_connection', private: true

      def call
        IO.popen(command) do |io|
          context.key = key
          context.filename = filename
          context.content_type = content_type
          context.file = file(io.read)
        end
      end

      private

      def command = "pg_dump -Fc #{current_database}"

      def content_type = 'application/octet-stream'

      def file(content)
        Tempfile
          .new
          .tap { _1.write(content) }
          .tap(&:rewind)
      end

      def filename = 'db.dump'

      def key = File.join(
        'backups',
        Time.current.strftime('%Y_%m_%d_%H_%M_%S_%L'),
        filename
      )
    end
  end
end
