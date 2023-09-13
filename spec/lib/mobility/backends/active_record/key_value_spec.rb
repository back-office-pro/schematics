# frozen_string_literal: true

require 'active_record'
require 'digest'
require 'method_source'
require 'mobility'
require 'mobility/backends/active_record/key_value'

describe Mobility::Backends::ActiveRecord::KeyValue do
  describe '#define_has_many_association' do
    subject do
      Digest::SHA256.hexdigest(described_class.method(:define_has_many_association).source)
    end

    it { is_expected.to eq('9374dc8f6150d7595a8269867203a03d79cdfb44cd34f6f00ab71fd5c3cc8114') }
  end
end
