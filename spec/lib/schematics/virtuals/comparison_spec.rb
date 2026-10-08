# frozen_string_literal: true

describe Schematics::Virtuals::Comparison do
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
        { name: 'category', type: 'belongs_to' },
        { name: 'sold_at', type: 'datetime' }
      ],
      virtuals: [
        name: 'discount_price', function: '$price - 10'
      ]
    )
  end
  let(:name) { 'big_price' }
  let(:function) { '$category.vat == 10 && ($sold_at == NULL || NOW() < $sold_at)' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_valid }

  its(:open_api_schema_type) { is_expected.to eq('boolean') }
  its(:open_api_query_type) { is_expected.to eq('boolean') }
  its(:preload) { is_expected.to eq([:category]) }
  its(:icon) { is_expected.to eq(:toggle_on) }
  its(:weight) { is_expected.to eq(1) }
  its(:available_options) { is_expected.to be_empty }
  its(:allowed_variables) { is_expected.to eq(%w[id price category sold_at discount_price created_at]) } # rubocop:disable Layout/LineLength
  its(:search_column) { is_expected.to eq(:big_price) }
  its(:search_predicate) { is_expected.to eq(:true) }
  its(:search_query) { is_expected.to eq(:big_price_true) }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.product.big_price') }

  its(:to_spec) do
    is_expected.to eq <<~TEXT.chomp
      A product has a **big price** virtual field which function is `$category.vat == 10 && ($sold_at == NULL || NOW() < $sold_at)`
    TEXT
  end

  its(:to_sql) do
    is_expected.to eq <<~SQL.squish
      (categories.vat = 10 AND (products.sold_at IS NULL OR current_timestamp < products.sold_at))
    SQL
  end

  its(:search_alias) do
    is_expected.to eq <<~RUBY
      ransacker :big_price do
        Arel.sql("(categories.vat = 10 AND (products.sold_at IS NULL OR current_timestamp < products.sold_at))")
      end
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      define_attribute_method :big_price
      def big_price
        self.category&.vat == 10 && (self.sold_at == nil || Time.current < self.sold_at)
      rescue StandardError => e
        Triggers::Errors::StandardError.build(e)
      end
      scope :big_price, -> { where(Arel.sql("(categories.vat = 10 AND (products.sold_at IS NULL OR current_timestamp < products.sold_at))")) }
      scope :not_big_price, -> { where.not(Arel.sql("(categories.vat = 10 AND (products.sold_at IS NULL OR current_timestamp < products.sold_at))")) }
    RUBY
  end

  context 'when virtual name is reserved' do
    let(:name) { 'otp_column_name' }

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
    let(:function) { '$name == NULL' }

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
    let(:function) { '$name == NULL' }

    it { is_expected.to be_valid }
  end

  describe '#format' do
    subject { virtual.format(value) }

    let(:value) { 'true' }

    it { is_expected.to eq('TRUE') }
  end

  describe '.klass' do
    subject { described_class.klass(entity:, function:) }

    it { is_expected.to eq(described_class) }
  end
end
