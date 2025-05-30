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
                database: Rails.root.join('storage', shard.to_s, "#{Rails.env}.sqlite3"),
                migrations_paths: Rails.root.join('db', shard.to_s, 'migrate')
              ),
            shard:
          )
          retry
        end
      end
    end
  end
end
