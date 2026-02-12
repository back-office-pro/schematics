# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Attributes::Token do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'access_token' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Generatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Encryptable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.not_to be_a(Schematics::Behaviours::Indexable) }
  it { is_expected.to be_encrypted }
  it { is_expected.to be_unique }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('access_token') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:default) { is_expected.to be_a(String) }
  its(:icon) { is_expected.to eq(:passport) }
  its(:to_s) { is_expected.to eq('access_token:string:uniq') }
  its(:to_spec) { is_expected.to eq('A entity has a **access token** attribute of type *token*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.access_token') }
  its(:openai_description) { is_expected.to eq('An attribute which represents a token') }

  its(:validators) do
    is_expected.to eq(uniqueness_with_deleted: { case_sensitive: true, allow_blank: true })
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :access_token, {:uniqueness_with_deleted=>{:case_sensitive=>true, :allow_blank=>true}}
    RUBY
  end

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      encrypts :access_token, deterministic: true
      has_secure_token :access_token, length: 32
    RUBY
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      token: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents a token',
            enum: %w[token]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            additionalProperties: false,
            anyOf: [
              '$ref': '#/$defs/required'
            ]
          }
        }
      }
    )
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class) }
  end
end
