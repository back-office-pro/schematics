# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'digest'
require 'method_source'

RSpec.shared_examples 'a monkey patched instance method' do |method_name, checksum|
  subject(:method_checksum) { Digest::SHA256.hexdigest(method.source) }

  let(:method) { described_class.instance_method(method_name) }
  let(:error_message) { "#{method} original source has changed to #{method_checksum}" }

  it { is_expected.to eq(checksum), error_message }
end

RSpec.shared_examples 'a monkey patched instance super method' do |method_name, checksum|
  subject(:method_checksum) { Digest::SHA256.hexdigest(method.source) }

  let(:method) { described_class.instance_method(method_name).super_method }
  let(:error_message) { "#{method} original source has changed to #{method_checksum}" }

  it { is_expected.to eq(checksum), error_message }
end

RSpec.shared_examples 'a monkey patched class method' do |method_name, checksum|
  subject(:method_checksum) { Digest::SHA256.hexdigest(method.source) }

  let(:method) { described_class.method(method_name) }
  let(:error_message) { "#{method} original source has changed to #{method_checksum}" }

  it { is_expected.to eq(checksum), error_message }
end

RSpec.shared_examples 'a monkey patched class super method' do |method_name, checksum|
  subject(:method_checksum) { Digest::SHA256.hexdigest(method.source) }

  let(:method) { described_class.method(method_name).super_method }
  let(:error_message) { "#{method} original source has changed to #{method_checksum}" }

  it { is_expected.to eq(checksum), error_message }
end

RSpec.shared_examples 'an overridden file' do |dependency, path, checksum|
  subject { Digest::SHA256.file(full_path) }

  let(:full_path) { Gem.loaded_specs[dependency.to_s].full_gem_path + path }

  it { is_expected.to eq(checksum), "#{full_path} original file has changed" }
end

RSpec.shared_examples 'an interpolable template' do
  include_context 'with user'

  it { is_expected.to be_a(Schematics::Interpolable) }

  describe '#interpolate' do
    subject { record.interpolate(user) }

    before { record.content = content }

    context 'when content has a variable' do
      let(:content) { 'Email: {{ email }}' }

      it { is_expected.to eq('Email: john.doe@nowhere.com') }
    end

    context 'when content has a nested variable' do
      let(:content) { 'Role: {{ role.name }}' }

      it { is_expected.to eq('Role: Manager') }
    end

    context 'when content has an association iteration' do
      let(:content) do
        <<~LIQUID
          {% for team in teams -%}
            {{ team.name }}
          {%- endfor %}
        LIQUID
      end

      it { is_expected.to eq('My Team 2My Team 1') }
    end

    context 'when content has an unknown variable' do
      let(:content) { 'Email: {{ foo }}' }

      it { is_expected.to eq('Email: ') }
    end

    context 'when content has a filter' do
      let(:content) { 'Email: {{ email | upcase }}' }

      it { is_expected.to eq('Email: JOHN.DOE@NOWHERE.COM') }
    end

    context 'when content has an unknown filter' do
      let(:content) { 'Email: {{ email | titleize }}' }

      it { is_expected.to eq('Email: ') }
    end

    context 'when content has a syntax error' do
      let(:content) { 'Email: {{ foo }' }

      it { is_expected.to be_nil }
    end
  end

  describe '#interpolation_errors' do
    subject { record.interpolation_errors }

    before do
      record.content = content
      record.interpolate(user)
    end

    context 'when content has a variable' do
      let(:content) { 'Email: {{ email }}' }

      it { is_expected.to be_empty }
    end

    context 'when content has a nested variable' do
      let(:content) { 'Role: {{ role.name }}' }

      it { is_expected.to be_empty }
    end

    context 'when content has an association iteration' do
      let(:content) do
        <<~LIQUID
          {% for team in teams -%}
            {{ team.name }}
          {%- endfor %}
        LIQUID
      end

      it { is_expected.to be_empty }
    end

    context 'when content has an unknown variable' do
      let(:content) { 'Email: {{ foo }}' }

      it { is_expected.to all(be_a(Liquid::UndefinedVariable)) }
    end

    context 'when content has a filter' do
      let(:content) { 'Email: {{ email | upcase }}' }

      it { is_expected.to be_empty }
    end

    context 'when content has an unknown filter' do
      let(:content) { 'Email: {{ email | titleize }}' }

      it { is_expected.to all(be_a(Liquid::UndefinedFilter)) }
    end

    context 'when content has a syntax error' do
      let(:content) { 'Email: {{ foo }' }

      it { is_expected.to all(be_a(Liquid::SyntaxError)) }
    end
  end
end
