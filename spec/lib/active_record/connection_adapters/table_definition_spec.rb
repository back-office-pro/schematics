# frozen_string_literal: true

require 'active_record'

describe ActiveRecord::ConnectionAdapters::TableDefinition do
  it_behaves_like 'a monkey patched instance method',
                  :timestamps,
                  '0125aa04c5844ec6532e005242b21dbfea751953407511550f168d2471da0246'
end
