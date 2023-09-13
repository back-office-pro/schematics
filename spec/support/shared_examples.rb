# frozen_string_literal: true

require 'digest'
require 'method_source'

RSpec.shared_examples 'a monkey patched instance method' do |method_name, checksum|
  subject { Digest::SHA256.hexdigest(method.source) }

  let(:method) { described_class.instance_method(method_name) }

  it { is_expected.to eq(checksum), "#{method} original source has changed" }
end

RSpec.shared_examples 'a monkey patched class method' do |method_name, checksum|
  subject { Digest::SHA256.hexdigest(method.source) }

  let(:method) { described_class.method(method_name) }

  it { is_expected.to eq(checksum), "#{method} original source has changed" }
end

RSpec.shared_examples 'an overridden file' do |dependency, path, checksum|
  subject { Digest::SHA256.file(full_path) }

  let(:full_path) { Gem.loaded_specs[dependency.to_s].full_gem_path + path }

  it { is_expected.to eq(checksum), "#{full_path} original file has changed" }
end
