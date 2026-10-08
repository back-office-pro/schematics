# frozen_string_literal: true

describe Schematics::Commands::AddPermission do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:schema) { Schematics::Schema.new(data:) }
  let(:data) { [name:] }
  let(:entity) { schema.find_entity_by_name(name) }
  let(:name) { 'client' }
  let(:attribute) { 'create' }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Add a permission **create** to **client**') }
  its(:weight) { is_expected.to eq(3) }

  describe '#generators' do
    subject { command.generators }

    its(:size) { is_expected.to eq(1) }
    its([0]) { is_expected.to be_a(PermissionGenerator) }

    its([0]) do
      is_expected.to have_attributes(
        name: 'Client',
        options: a_hash_including(action: attribute),
        behavior: :invoke
      )
    end
  end

  context 'with a parent entity' do
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
    let(:name) { 'portfolio' }

    describe '#generators' do
      subject { command.generators }

      it { is_expected.to be_empty }
    end
  end

  context 'with a child entity' do
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
    let(:name) { 'brokerage_account' }

    describe '#generators' do
      subject { command.generators }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(PermissionGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'BrokerageAccount',
          options: a_hash_including(action: 'create'),
          behavior: :invoke
        )
      end
    end
  end
end
