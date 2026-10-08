# frozen_string_literal: true

describe Schematics::Attributes::Year do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'user') }
  let(:name) { 'created_at/year' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
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
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }

  its(:group_method) { is_expected.to eq(:group_by_year) }
  its(:to_sql) { is_expected.to eq('users.created_at') }

  its(:to_spec) do
    is_expected.to eq('A user has a **created at/year** attribute of type *datetime*')
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { Time.parse('2021/01/01 10:00 +0000').in_time_zone }

    it { is_expected.to eq('Year 2021') }
  end
end
