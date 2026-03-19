# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Commands::RenameAttribute do
  subject(:command) { described_class.new(entity:, attribute:, target:) }

  include_context 'with custom generated attribute'

  let(:schema) { Schematics::Schema.new(data:) }
  let(:data) { [name:] }
  let(:name) { 'client' }
  let(:attribute_name) { 'first_name' }
  let(:new_attribute_name) { 'name' }
  let(:type) { 'string' }
  let(:entity) { schema.find_entity_by_name(name) }
  let(:attribute) do
    Schematics::Attributes::Attribute.build(
      entity:,
      type:,
      name: attribute_name
    )
  end
  let(:target) do
    Schematics::Attributes::Attribute.build(
      entity:,
      type:,
      name: new_attribute_name
    )
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }

  its(:weight) { is_expected.to eq(2) }

  its(:to_spec) do
    is_expected.to eq('Rename the attribute **first name** of **client** to **name**')
  end

  describe '#generators' do
    subject { command.generators }

    context 'when attribute is migratable' do
      its(:size) { is_expected.to eq(2) }
      its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([1]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'rename_first_name_to_name_in_clients',
          behavior: :invoke
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.client.name',
          options: a_hash_including(rename: 'activerecord.attributes.client.first_name'),
          behavior: :invoke
        )
      end
    end

    context 'when attribute is not migratable' do
      let(:type) { 'attachment' }

      its(:size) { is_expected.to eq(1) }
      its([0]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.client.name',
          options: a_hash_including(rename: 'activerecord.attributes.client.first_name'),
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

      its(:size) { is_expected.to eq(2) }
      its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([1]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'rename_name_to_label_in_portfolios',
          behavior: :invoke
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.portfolio.label',
          options: a_hash_including(rename: 'activerecord.attributes.portfolio.name'),
          behavior: :invoke
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
    let(:new_attribute_name) { 'charges' }
    let(:type) { 'percentage' }

    describe '#generators' do
      subject { command.generators }

      its(:size) { is_expected.to eq(2) }
      its([0]) { is_expected.to be_a(Rails::Generators::MigrationGenerator) }
      its([1]) { is_expected.to be_a(TranslationGenerator) }

      its([0]) do
        is_expected.to have_attributes(
          name: 'rename_fees_to_charges_in_portfolios',
          behavior: :invoke
        )
      end

      its([1]) do
        is_expected.to have_attributes(
          name: 'activerecord.attributes.brokerage_account.charges',
          options: a_hash_including(rename: 'activerecord.attributes.brokerage_account.fees'),
          behavior: :invoke
        )
      end
    end
  end
end
