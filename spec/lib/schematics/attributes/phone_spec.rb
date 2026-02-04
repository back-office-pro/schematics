# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Attributes::Phone do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'phone' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Generatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Indexable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Unnormalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Untranslatable) }
  it { is_expected.not_to be_translated }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('phone') }
  its(:open_api_body_type) { is_expected.to eq('string') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:input_name) { is_expected.to eq('user[phone]') }
  its(:icon) { is_expected.to eq(:phone) }
  its(:default) { is_expected.to match(/\+3306\d{8}/) }
  its(:validators) { is_expected.to eq(phone: { allow_blank: true }) }
  its(:search_column) { is_expected.to eq(:phone) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:phone_i_cont) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.phone') }
  its(:to_s) { is_expected.to eq('phone:string:index') }
  its(:normalization) { is_expected.to be_nil }
  its(:to_spec) { is_expected.to eq('A user has a **phone** attribute of type *phone number*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.phone') }
  its(:openai_description) { is_expected.to eq('An attribute which represents a phone number') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Unique,
      Schematics::Options::CaseInsensitive,
      Schematics::Options::Min,
      Schematics::Options::Limit,
      Schematics::Options::Length
    )
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :phone, {:phone=>{:allow_blank=>true}}
    RUBY
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      phone: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents a phone number',
            enum: %w[phone]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            additionalProperties: false,
            anyOf: [
              { '$ref': '#/$defs/required' },
              { '$ref': '#/$defs/default' },
              { '$ref': '#/$defs/readonly' },
              { '$ref': '#/$defs/min' },
              { '$ref': '#/$defs/limit' },
              { '$ref': '#/$defs/length' },
              { '$ref': '#/$defs/unique' },
              { '$ref': '#/$defs/case_insensitive' }
            ]
          }
        }
      }
    )
  end

  context 'when phone is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }

    its(:to_s) { is_expected.to eq('phone:string:uniq') }

    its(:validators) do
      is_expected.to eq(
        uniqueness_with_deleted: { case_sensitive: true, allow_blank: true },
        phone: { allow_blank: true }
      )
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :phone, {:uniqueness_with_deleted=>{:case_sensitive=>true, :allow_blank=>true}, :phone=>{:allow_blank=>true}}
      RUBY
    end
  end

  context 'when phone is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:validators) { is_expected.to eq(presence: true, phone: { allow_blank: false }) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :phone, {:presence=>true, :phone=>{:allow_blank=>false}}
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { '+330611223344' }

    it { is_expected.to eq('+330611223344') }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::String,
        Schematics::Attributes::Text,
        Schematics::Attributes::Action,
        Schematics::Attributes::Address,
        Schematics::Attributes::Color,
        Schematics::Attributes::Country,
        Schematics::Attributes::Email,
        Schematics::Attributes::Ip,
        Schematics::Attributes::Locale,
        Schematics::Attributes::Mime,
        Schematics::Attributes::ModelField,
        Schematics::Attributes::Model,
        Schematics::Attributes::TimeZone,
        Schematics::Attributes::UserAgent,
        Schematics::Attributes::Url,
        Schematics::Attributes::Code
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
