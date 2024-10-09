# frozen_string_literal: true

require 'active_record'
require 'active_record/connection_adapters/sqlite3_adapter'

describe ActiveRecord::ConnectionAdapters::SQLite3Adapter do
  it_behaves_like 'a monkey patched instance method',
                  :configure_connection,
                  'dc4818909c74e31cbb5e730100f558da3bbfdfe620c28a222c4cb7fc617e392a'
end
