# frozen_string_literal: true

module Core
  module Backups
    class Restore
      delegate :backup, to: :context, private: true

      def call
        backup.open do |file|
          `pg_restore -Fc #{file.path}`
        end
      end
    end
  end
end
