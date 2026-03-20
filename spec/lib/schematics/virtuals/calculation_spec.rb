# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Virtuals::Calculation do
  subject(:virtual) { described_class.new(entity:, name:, function:, options:) }

  let(:schema) { Schematics::Schema.new(data:) }
  let(:data) { [] }
  let(:parent) { nil }
  let(:entity) do
    Schematics::Entities::Entity.new(
      schema:,
      name: 'product',
      options: {
        descriptor: 'full_name',
        parent:
      },
      attributes: [
        { name: 'price', type: 'float' },
        { name: 'category', type: 'belongs_to' }
      ],
      virtuals: [
        name: 'discount_price', function: '$price - 10'
      ]
    )
  end
  let(:name) { 'tax_inclusive_price' }
  let(:function) { '$price * $category.vat' }
  let(:options) do
    {
      unit: '$',
      precision: 2
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_valid }

  its(:open_api_schema_type) { is_expected.to eq('float') }
  its(:open_api_query_type) { is_expected.to eq('float') }
  its(:to_sql) { is_expected.to eq('(products.price * categories.vat)') }
  its(:preload) { is_expected.to eq([:category]) }
  its(:icon) { is_expected.to eq(:square_root_alt) }
  its(:unit) { is_expected.to eq('$') }
  its(:precision) { is_expected.to eq(2) }
  its(:weight) { is_expected.to eq(1) }
  its(:allowed_variables) { is_expected.to eq(%w[price discount_price]) }
  its(:search_column) { is_expected.to eq(:tax_inclusive_price) }
  its(:search_predicate) { is_expected.to eq(:eq) }
  its(:search_query) { is_expected.to eq(:tax_inclusive_price_eq) }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.product.tax_inclusive_price') }

  its(:to_spec) do
    is_expected.to eq <<~TEXT.chomp
      A product has a **tax inclusive price** virtual field which function is `$price * $category.vat`
    TEXT
  end

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Unit,
      Schematics::Options::Precision,
      Schematics::Options::Separator,
      Schematics::Options::Delimiter
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      define_attribute_method :tax_inclusive_price
      def tax_inclusive_price
        self.price.to_f * self.category&.vat.to_f
      rescue StandardError => e
        Triggers::Errors::StandardError.build(e)
      end
    RUBY
  end

  context 'when virtual name is reserved' do
    let(:name) { 'paper_trail_version' }

    it { is_expected.not_to be_valid }
  end

  context 'when virtual name is dangerous' do
    let(:name) { 'association' }

    it { is_expected.not_to be_valid }
  end

  context 'when virtual name is already taken by another virtual' do
    let(:name) { 'discount_price' }

    it { is_expected.not_to be_valid }
  end

  context 'when virtual name is already taken by another attribute' do
    let(:name) { 'price' }

    it { is_expected.not_to be_valid }
  end

  context 'when virtual name is already taken by another virtual in the parent entity' do
    let(:name) { 'full_name' }
    let(:parent) { 'user' }

    it { is_expected.not_to be_valid }
  end

  context 'when virtual name is already taken by another attribute in the parent entity' do
    let(:name) { 'email' }
    let(:parent) { 'user' }

    it { is_expected.not_to be_valid }
  end

  context 'when virtual name is already taken by another attribute in a child entity' do
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
    let(:name) { 'age' }
    let(:function) { '$fees * 10' }

    it { is_expected.to be_valid }
  end

  context 'when virtual name is already taken by another virtual in a child entity' do
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
          ],
          virtuals: [
            id: '03577ee9-f5b5-40e2-b8b4-0f9741d190c4',
            name: 'amount',
            function: '$age * 10'
          ]
        }
      ]
    end
    let(:entity) { schema.find_entity_by_name('brokerage_account') }
    let(:name) { 'amount' }
    let(:function) { '$fees * 10' }

    it { is_expected.to be_valid }
  end

  describe '#format' do
    subject { virtual.format(value) }

    let(:value) { 100.099 }

    it { is_expected.to eq('$100.10') }
  end

  describe '.klass' do
    subject { described_class.klass(entity:, function:) }

    it { is_expected.to eq(described_class) }
  end
end
