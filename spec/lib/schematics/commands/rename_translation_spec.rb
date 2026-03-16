# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Commands::RenameTranslation do
  subject(:command) { described_class.new(entity:, attribute:, target:) }

  let(:schema) { Schematics::Schema.new(data:) }
  let(:data) { [name:] }
  let(:name) { 'client' }
  let(:attribute_name) { 'surname' }
  let(:new_attribute_name) { 'name' }
  let(:entity) { schema.find_entity_by_name(name) }
  let(:attribute) { Schematics::Attributes::String.new(entity:, name: attribute_name) }
  let(:target) { Schematics::Attributes::String.new(entity:, name: new_attribute_name) }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:to_spec) { is_expected.to eq('Rename a **client** translation') }
  its(:weight) { is_expected.to eq(3) }

  describe '#generators' do
    subject { command.generators }

    context 'when target is not a state machine event' do
      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.client.name',
          options: a_hash_including(rename: 'activerecord.attributes.client.surname'),
          behavior: :invoke
        )
      end
    end

    context 'when target is a state machine event' do
      let(:state_machine) { Schematics::Attributes::StateMachine.new(entity:, name: 'state') }
      let(:target) { Schematics::Options::StateMachineEvent.new(state_machine:, name: 'follow') }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.events.client.follow',
          options: a_hash_including(rename: 'activerecord.attributes.client.surname'),
          behavior: :invoke
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
    let(:attribute_name) { 'name' }
    let(:new_attribute_name) { 'label' }

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
    let(:attribute_name) { 'fees' }
    let(:new_attribute_name) { 'charges' }

    describe '#generators' do
      subject { command.generators }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.brokerage_account.charges',
          options: a_hash_including(rename: 'activerecord.attributes.brokerage_account.fees'),
          behavior: :invoke
        )
      end
    end
  end
end
