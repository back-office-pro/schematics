# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_record'
require 'active_record/connection_adapters/sqlite3_adapter'

describe ActiveRecord::ConnectionAdapters::SQLite3Adapter do
  it_behaves_like 'a monkey patched instance method',
                  :native_database_types,
                  'f28ee4c45399cffeee4f36030e82e3402327eddcc9cd6e92811570c4b7d7474f'
end
