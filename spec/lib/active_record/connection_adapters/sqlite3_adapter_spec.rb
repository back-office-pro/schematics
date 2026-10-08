# frozen_string_literal: true

require 'active_record'
require 'active_record/connection_adapters/sqlite3_adapter'

describe ActiveRecord::ConnectionAdapters::SQLite3Adapter do
  it_behaves_like 'a monkey patched instance method',
                  :native_database_types,
                  '1b25f7133ee710d3e6cf248432482d1909ce3324205ae8948abecd8db6d38348'
end
