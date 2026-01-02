# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Virtuals::Concatenation do
  subject(:virtual) { described_class.new(entity:, name:, function:, options:) }

  let(:entity) do
    Schematics::Entities::Entity.new(
      name: 'user',
      options: {
        descriptor: 'full_name'
      },
      attributes: [
        { name: 'first_name', type: 'string' },
        { name: 'last_name', type: 'string' },
        { name: 'profile', type: 'belongs_to' }
      ],
      virtuals: [
        { name: 'name', function: '$first_name $last_name' }
      ]
    )
  end
  let(:name) { 'full_name' }
  let(:function) { '$first_name $profile.last_name' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Multisearchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_valid }

  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:to_sql) { is_expected.to eq("(users.first_name || ' ' || profiles.last_name)") }
  its(:preload) { is_expected.to eq([:profile]) }
  its(:icon) { is_expected.to eq(:align_justify) }
  its(:weight) { is_expected.to eq(1) }
  its(:available_options) { is_expected.to be_empty }
  its(:allowed_variables) { is_expected.to eq(%w[id first_name last_name profile name created_at]) }
  its(:search_column) { is_expected.to eq(:full_name) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:full_name_i_cont) }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.full_name') }

  its(:to_spec) do
    is_expected.to eq <<~TEXT.chomp
      A user has a **full name** virtual field which function is `$first_name $profile.last_name`
    TEXT
  end

  its(:search_alias) do
    is_expected.to eq <<~RUBY
      ransacker :full_name do
        Arel.sql("(users.first_name || ' ' || profiles.last_name)")
      end
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      define_attribute_method :full_name
      def full_name
        "\#{first_name_formatted} \#{profile&.last_name_formatted}"
      rescue StandardError => e
        Triggers::Errors::StandardError.build(e)
      end
    RUBY
  end

  context 'when virtual name is reserved' do
    let(:name) { 'paper_trail_versions' }

    it { is_expected.not_to be_valid }
  end

  context 'when virtual name is dangerous' do
    let(:name) { 'association' }

    it { is_expected.not_to be_valid }
  end

  context 'when virtual name is already taken by another virtual' do
    let(:name) { 'name' }

    it { is_expected.not_to be_valid }
  end

  context 'when virtual name is already taken by another attribute' do
    let(:name) { 'first_name' }

    it { is_expected.not_to be_valid }
  end

  describe '.klass' do
    subject { described_class.klass(entity:, function:) }

    it { is_expected.to eq(described_class) }
  end
end
