# frozen_string_literal: true

# TODO: remove when upgrading to Rails 8
module ActiveRecord
  module Override
    module ConnectionAdapters
      module SQLite3Adapter
        def configure_connection
          super

          return unless @config[:timeout]

          timeout = self.class.type_cast_config_to_integer(@config[:timeout])
          @raw_connection.busy_handler_timeout = timeout
        end
      end
    end
  end
end
