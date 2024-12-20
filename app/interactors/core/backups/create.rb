# frozen_string_literal: true

module Core
  module Backups
    class Create
      include Interactor
      delegate :create_and_upload!, to: ::ActiveStorage::Blob, private: true

      def call
        IO.popen(command) do |io|
          context.file = create_and_upload!(key:, filename:, content_type:, io: file(io.read))
        end
      end

      private

      def command = %(sqlite3 #{db_path} ".dump #{tables}")

      def db_path = ::Rails
        .root
        .join('storage', "#{Rails.env}.sqlite3")

      def tables
        Array(context.tables).join(' ')
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
