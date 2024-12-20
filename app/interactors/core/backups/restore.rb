# frozen_string_literal: true

module Core
  module Backups
    class Restore
      include Interactor
      delegate :disconnect!, to: 'ActiveRecord::Base.connection_pool', private: true
      delegate :backup, :clean, to: :context, private: true

      before :disconnect!

      def call
        backup.open { system command(_1) }
      end

      private

      def command(file)
        %(sqlite3 #{db_path} #{clean ? "< #{file.path}" : %(".read #{file.path}")})
      end

      def db_path = ::Rails
        .root
        .join('storage', "#{Rails.env}.sqlite3")
    end
  end
end
