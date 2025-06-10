# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module ActiveRecord
  module Override
    module ConnectionAdapters
      module ConnectionHandler
        # :reek:BooleanParameter
        def retrieve_connection_pool(
          connection_name,
          role: ActiveRecord::Base.current_role,
          shard: ActiveRecord::Base.current_shard,
          strict: false
        )
          super
        rescue ConnectionNotDefined
          establish_connection(
            Rails
              .configuration
              .database_configuration.dig(Rails.env, 'primary')
              .merge(
                database: [shard, Rails.env].join('_'),
                migrations_paths: Rails.root.join('db', shard.to_s, 'migrate')
              ),
            shard:
          )
          %w[search cache].each do |db_name|
            config = Rails.configuration.database_configuration.dig(Rails.env, db_name)
            migrations_paths = Rails.root.join('db', shard.to_s, "#{db_name}_migrate")
            database = Rails.root.join('storage', shard.to_s, "#{Rails.env}_#{db_name}.sqlite3")
            next unless config

            establish_connection(
              config.merge(database:, migrations_paths:),
              shard: [shard, db_name].join('/')
            )
          end
          retry
        end
      end
    end
  end
end
