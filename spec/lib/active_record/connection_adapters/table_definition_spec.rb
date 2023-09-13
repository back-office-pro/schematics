# frozen_string_literal: true

require 'active_record'
require 'digest'
require 'method_source'

describe ActiveRecord::ConnectionAdapters::TableDefinition do
  describe '#timestamps' do
    subject { Digest::SHA256.hexdigest(described_class.instance_method(:timestamps).source) }

    it { is_expected.to eq('0125aa04c5844ec6532e005242b21dbfea751953407511550f168d2471da0246') }
  end
end
