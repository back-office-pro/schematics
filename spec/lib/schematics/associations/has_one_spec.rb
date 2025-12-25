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

describe Schematics::Associations::HasOne do
  subject(:association) do
    Schematics::Associations::Association.build(
      type: 'has_one',
      entity:,
      name: 'schema'
    )
  end

  let(:data) do
    [
      {
        name: 'entity',
        options: {
          descriptor: 'type'
        },
        attributes: [
          { name: 'type', type: 'string' }
        ]
      },
      {
        name: 'schema'
      }
    ]
  end
  let(:schema) { Schematics::Schema.new(data:) }
  let(:entity) { Schematics::Entities::Entity.new(schema:, **data.first) }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }

  its(:type) { is_expected.to eq('has_one') }
  its(:name) { is_expected.to eq('entity') }
  its(:class_name) { is_expected.to eq('Entity') }
  its(:column_name) { is_expected.to eq('schema_id') }
  its(:inverse_of) { is_expected.to eq('schema') }
  its(:open_api_schema_type) { is_expected.to eq(id: 'string', type: 'string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:weight) { is_expected.to eq(3) }
  its(:search_column) { is_expected.to eq(:entity_type) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:entity_i_cont) }
  its(:to_spec) { is_expected.to eq('A schema has one **entity**') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.entity') }
  its('descriptor.name') { is_expected.to eq('type') }

  its(:to_str) do
    is_expected.to eq <<~RUBY
      scope :with_entity, -> { includes([:entity]) }
      has_one :entity,
              -> { with_deleted },
              class_name: 'Entity',
              foreign_key: 'schema_id',
              inverse_of: :schema,
              autosave: true
    RUBY
  end
end
