# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_record'
require 'active_record/connection_adapters/abstract/connection_handler'

describe ActiveRecord::ConnectionAdapters::ConnectionHandler do
  it_behaves_like 'a monkey patched instance method',
                  :retrieve_connection_pool,
                  '1c4eb6178d757fdc2002cb50eae0aa3bd32d9869ccc0d7bfddb4715dfe28d03f'
end
