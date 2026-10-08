# frozen_string_literal: true

describe Schematics::Attributes::String do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new(data:) }
  let(:data) { [] }
  let(:parent) { nil }
  let(:entity) do
    Schematics::Entities::Entity.new(
      schema:,
      name: 'user',
      options: {
        descriptor: 'full_name',
        parent:
      },
      attributes: [
        name: 'first_name', type: 'string'
      ],
      virtuals: [
        name: 'full_name', function: '$first_name $last_name'
      ]
    )
  end
  let(:name) { 'last_name' }
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
  it { is_expected.to be_a(Schematics::Behaviours::Normalizable) }
  it { is_expected.to be_valid }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('last_name') }
  its(:open_api_body_type) { is_expected.to eq('string') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:input_name) { is_expected.to eq('user[last_name]') }
  its(:icon) { is_expected.to eq(:align_justify) }
  its(:default) { is_expected.to be_a(String) }
  its(:validators) { is_expected.to be_empty }
  its(:search_column) { is_expected.to eq(:last_name) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:last_name_i_cont) }
  its('validators.to_str') { is_expected.to be_blank }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.last_name') }
  its(:to_s) { is_expected.to eq('last_name:string:index') }
  its(:to_spec) { is_expected.to eq('A user has a **last name** attribute of type *string*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.last_name') }
  its(:openai_description) { is_expected.to eq('An attribute which represents a string') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::Translated,
      Schematics::Options::Unique,
      Schematics::Options::CaseInsensitive,
      Schematics::Options::Min,
      Schematics::Options::Limit,
      Schematics::Options::Length,
      Schematics::Options::Normalization
    )
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      string: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents a string',
            enum: %w[string]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            additionalProperties: false,
            anyOf: [
              { '$ref': '#/$defs/required' },
              { '$ref': '#/$defs/default' },
              { '$ref': '#/$defs/readonly' },
              { '$ref': '#/$defs/translated' },
              { '$ref': '#/$defs/normalization' },
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

  context 'when string is unique' do
    let(:options) { { unique: true } }

    it { is_expected.to be_unique }

    its(:to_s) { is_expected.to eq('last_name:string:uniq') }

    its(:validators) do
      is_expected.to eq(uniqueness_with_deleted: { case_sensitive: true, allow_blank: true })
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :last_name, {uniqueness_with_deleted: {case_sensitive: true, allow_blank: true}}
      RUBY
    end
  end

  context 'when string is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:validators) { is_expected.to eq(presence: true) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :last_name, {presence: true}
      RUBY
    end
  end

  context 'when attribute name is reserved' do
    let(:name) { 'slug' }

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is dangerous' do
    let(:name) { 'association' }

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is already taken by another attribute' do
    let(:name) { 'first_name' }

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is already taken by another virtual' do
    let(:name) { 'full_name' }

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is already taken by another attribute in the parent entity' do
    let(:name) { 'action' }
    let(:parent) { 'permission' }

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is already taken by another virtual in the parent entity' do
    let(:name) { 'name' }
    let(:parent) { 'permission' }

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is already taken by another attribute in a child entity' do
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

    it { is_expected.not_to be_valid }
  end

  context 'when attribute name is already taken by another virtual in a child entity' do
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

    it { is_expected.to be_valid }
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
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
        Schematics::Attributes::Phone,
        Schematics::Attributes::TimeZone,
        Schematics::Attributes::UserAgent,
        Schematics::Attributes::Url,
        Schematics::Attributes::Code
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
