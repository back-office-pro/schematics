# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module ActiveRecord
  module Override
    module ConnectionAdapters
      module SQLite3Adapter
        def native_database_types
          super.merge jsonb: { name: 'jsonb' }
        end
      end
    end
  end
end
