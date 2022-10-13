# frozen_string_literal: true

module Application
  module ActiveStorage
    class Backup
      include Interactor
      delegate :create_and_upload!, to: 'ActiveStorage::Blob', private: true
      delegate :current_database, to: 'ActiveRecord::Base.connection', private: true

      def call
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
