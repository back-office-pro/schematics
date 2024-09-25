# frozen_string_literal: true

module Core
  module Backups
    class Restore
      include Interactor

      delegate :current_database, to: 'ActiveRecord::Base.lease_connection', private: true
      delegate :disconnect!, to: 'ActiveRecord::Base.connection_pool', private: true
      delegate :backup, to: :context, private: true

      before :disconnect!

      def call
        backup.open { |file| `pg_restore -vc -d #{current_database} #{file.path}` }
      end
    end
  end
end
