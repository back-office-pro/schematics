# frozen_string_literal: true

require 'digest'
require 'method_source'
require 'open_api/router'

describe OpenApi::Router do
  describe '#routes' do
    subject { Digest::SHA256.hexdigest(described_class.instance_method(:routes).source) }

    it { is_expected.to eq('dd1b3554c4e9243762da72276a1647b35adc8f172875e9bc36424620efc53d10') }
  end
end
