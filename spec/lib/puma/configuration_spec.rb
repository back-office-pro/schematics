# frozen_string_literal: true

require 'digest'
require 'method_source'
require 'puma'
require 'puma/configuration'

describe Puma::Configuration do
  describe '#config_files' do
    subject { Digest::SHA256.hexdigest(described_class.instance_method(:config_files).source) }

    it { is_expected.to eq('4827f23bf69d1b2bbb33c47f85cba7862d325fe2e6a71ce1984df3f38a1a0e21') }
  end
end
