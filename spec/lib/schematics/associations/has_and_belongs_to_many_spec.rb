# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Associations::HasAndBelongsToMany do
  subject(:association) do
    Schematics::Associations::Association.build(
      type: 'has_and_belongs_to_many',
      entity:,
      name:,
      options:
    )
  end

  let(:schema) { Schematics::Schema.new(data:) }
  let(:data) { [] }
  let(:parent) { nil }
  let(:entity) do
    Schematics::Entities::Entity.new(
      schema:,
      name: 'role',
      options: {
        descriptor: 'name',
        parent:
      },
      associations: [
        name: 'users', type: 'has_and_belongs_to_many'
      ],
      attributes: [
        name: 'name', type: 'string'
      ]
    )
  end
  let(:name) { 'permissions' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }

  its(:type) { is_expected.to eq('has_and_belongs_to_many') }
  its(:name) { is_expected.to eq('permissions') }
  its(:column_name) { is_expected.to eq('permission_ids') }
  its(:class_name) { is_expected.to eq('Permission') }
  its(:open_api_schema_type) { is_expected.to eq([id: 'string', name: 'string']) }
  its(:open_api_body_type) { is_expected.to eq(['string']) }
  its(:permitted_params) { is_expected.to eq(permission_ids: []) }
  its(:input_name) { is_expected.to eq('role[permission_ids][]') }
  its(:allowed_association_types) { is_expected.to include('user', 'role') }
  its(:association_type) { is_expected.to eq('permission') }
  its(:foreign_key) { is_expected.to eq('role_id') }
  its(:inverse_association) { is_expected.to be_a(described_class) }
  its(:icon) { is_expected.to eq(:lock) }
  its(:weight) { is_expected.to eq(3) }
  its(:to_spec) { is_expected.to eq('A role has many **permissions**') }
  its(:group_by) { is_expected.to be_nil }
  its(:filter_by) { is_expected.to eq(:itself) }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.role.permissions') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Type,
      Schematics::Options::GroupBy,
      Schematics::Options::FilterBy
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      scope :with_permissions, -> { includes([:permissions]) }
      has_and_belongs_to_many :permissions,
                              class_name: 'Permission',
                              join_table: 'permissions_roles',
                              foreign_key: 'role_id',
                              association_foreign_key: 'permission_id'
    RUBY
  end

  context 'when association is grouped' do
    let(:options) { { group_by: 'model' } }

    its(:group_by) { is_expected.to eq(:model_formatted) }
  end

  context 'when association is filtered' do
    let(:options) { { filter_by: 'model' } }

    its(:filter_by) { is_expected.to eq(:model) }
  end

  context 'when association name is already taken by another association' do
    let(:name) { 'users' }

    it { is_expected.not_to be_valid }
  end

  context 'when association name is already taken by another association in the parent entity' do
    let(:name) { 'recipients' }
    let(:parent) { 'message' }

    it { is_expected.not_to be_valid }
  end

  context 'when association name is already taken by another association in a child entity' do
    let(:data) do
      [
        {
          id: '3cceed80-55c1-445f-a47b-44705c702c3d',
          name: 'portfolio',
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'users'
          ],
          attributes: [
            id: '170ac71c-ffca-4cff-bfaf-bb89afb9b735',
            name: 'name',
            type: 'string'
          ]
        },
        {
          id: '5311570e-b976-410d-b5d9-48eb928c8fb1',
          name: 'brokerage_account',
          options: {
            parent: 'portfolio'
          },
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'teams'
          ],
          attributes: [
            id: 'd46f9336-d17e-4840-bd90-c36c8b44ca6d',
            name: 'fees',
            type: 'percentage'
          ]
        },
        {
          id: '635476ac-2c51-4ce2-a23b-2c8ba6535598',
          name: 'life_insurance',
          options: {
            parent: 'portfolio'
          },
          associations: [
            type: 'has_and_belongs_to_many',
            name: 'roles'
          ],
          attributes: [
            id: '286ce97a-d000-4c26-93ea-7a969850d124',
            name: 'age',
            type: 'integer'
          ]
        }
      ]
    end
    let(:entity) { schema.find_entity_by_name('brokerage_account') }
    let(:name) { 'roles' }

    it { is_expected.not_to be_valid }
  end

  context 'when association name is the same as entity name' do
    let(:name) { 'roles' }

    it { is_expected.not_to be_valid }
  end

  context 'when association has a parent entity' do
    let(:parent) { 'message' }

    its(:foreign_key) { is_expected.to eq('message_id') }

    its(:to_str) do
      is_expected.to eq <<~RUBY
        scope :with_permissions, -> { includes([:permissions]) }
        has_and_belongs_to_many :permissions,
                                class_name: 'Permission',
                                join_table: 'messages_permissions',
                                foreign_key: 'message_id',
                                association_foreign_key: 'permission_id'
      RUBY
    end
  end
end
