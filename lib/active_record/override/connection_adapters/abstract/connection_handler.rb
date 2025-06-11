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
          if Rails.env.test?
            connect_to_shard('demo', 'demo/test', 'demo/migrate')
            connect_to_shard('default/search', 'demo/test_search', 'demo/search_migrate')
          else
            connect_to_shard(shard, "#{shard}_#{Rails.env}", "#{shard}/migrate")
            connect_to_shard("#{shard}/search", "#{shard}/#{Rails.env}_search", "#{shard}/search_migrate") # rubocop:disable Layout/LineLength
            connect_to_shard("#{shard}/cable", "#{shard}/#{Rails.env}_cable", "#{shard}/cable_migrate") # rubocop:disable Layout/LineLength
          end
          retry
        end

        private

        # :reek:FeatureEnvy
        def connect_to_shard(shard, db, migration_path)
          establish_connection(
            Rails
              .configuration
              .database_configuration
              .dig(Rails.env, shard.to_s.split('/').second || 'primary')
              .merge(
                database: db.include?('/') ? Rails.root.join('storage', "#{db}.sqlite3") : db,
                migrations_paths: Rails.root.join('db', migration_path)
              ),
            shard: shard.to_sym
          )
        end
      end
    end
  end
end
