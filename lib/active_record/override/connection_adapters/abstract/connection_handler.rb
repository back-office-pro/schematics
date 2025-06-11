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
            establish_connection(
              db_config_for(:primary).merge(
                database: Rails.root.join('storage/demo/test.sqlite3'),
                migrations_paths: Rails.root.join('db/demo/migrate')
              ),
              shard: :demo
            )
            establish_connection(
              db_config_for(:search).merge(
                database: Rails.root.join('storage/demo/test_search.sqlite3'),
                migrations_paths: Rails.root.join('db/demo/search_migrate')
              ),
              shard: :'default/search'
            )
          else
            establish_connection(
              db_config_for(:primary).merge(
                database: "#{shard}_#{Rails.env}",
                migrations_paths: Rails.root.join('db', shard.to_s, 'migrate')
              ),
              shard:
            )
            establish_connection(
              db_config_for(:search).merge(
                database: Rails.root.join('storage', shard.to_s, "#{Rails.env}_search.sqlite3"),
                migrations_paths: Rails.root.join('db', shard.to_s, 'search_migrate')
              ),
              shard: :"#{shard}/search"
            )
            establish_connection(
              db_config_for(:cache).merge(
                database: Rails.root.join('storage', shard.to_s, "#{Rails.env}_cache.sqlite3"),
                migrations_paths: Rails.root.join('db', shard.to_s, 'cache_migrate')
              ),
              shard: :"#{shard}/cache"
            )
          end
          retry
        end

        private

        def db_config_for(database)
          Rails.configuration.database_configuration.dig(Rails.env, database.to_s).symbolize_keys
        end
      end
    end
  end
end
