# frozen_string_literal: true

require 'digest'
require 'method_source'

RSpec.shared_examples 'a monkey patched instance method' do |method, checksum|
  subject { Digest::SHA256.hexdigest(described_class.instance_method(method).source) }

  it { is_expected.to eq(checksum) }
end

RSpec.shared_examples 'a monkey patched class method' do |method, checksum|
  subject { Digest::SHA256.hexdigest(described_class.method(method).source) }

  it { is_expected.to eq(checksum) }
end
