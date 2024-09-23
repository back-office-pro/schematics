# frozen_string_literal: true

module Core
  module Backups
    class Restore
      include Interactor
      delegate :backup, to: :context, private: true

      def call
        backup.open { |file| `pg_restore #{file.path}` }
      end
    end
  end
end
