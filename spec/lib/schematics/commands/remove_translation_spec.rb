# frozen_string_literal: true

describe Schematics::Commands::RemoveTranslation do
  subject(:command) { described_class.new(entity:, attribute:) }

  let(:schema) { Schematics::Schema.new(data:) }
  let(:data) { [name:] }
  let(:name) { 'client' }
  let(:attribute_name) { 'name' }
  let(:type) { 'string' }
  let(:entity) { schema.find_entity_by_name(name) }
  let(:attribute) do
    Schematics::Attributes::Attribute.build(
      entity:,
      type:,
      name: attribute_name
    )
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Remove a **client** translation') }
  its(:weight) { is_expected.to eq(3) }

  describe '#generators' do
    subject { command.generators }

    context 'when attribute is not a state machine event' do
      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.client.name',
          behavior: :revoke
        )
      end
    end

    context 'when attribute is a state machine event' do
      let(:state_machine) { Schematics::Attributes::StateMachine.new(entity:, name: 'state') }
      let(:attribute) { Schematics::Options::StateMachineEvent.new(state_machine:, name: 'follow') }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.events.client.follow',
          behavior: :revoke
        )
      end
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

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.portfolio.name',
          behavior: :revoke
        )
      end
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
    let(:attribute_name) { 'fees' }
    let(:type) { 'percentage' }

    describe '#generators' do
      subject { command.generators }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.brokerage_account.fees',
          behavior: :revoke
        )
      end
    end
  end
end
