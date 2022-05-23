# frozen_string_literal: true

describe Schematics::Attributes::Month do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'created_at/month' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }

  its(:group_method) { is_expected.to eq(:group_by_month) }
  its(:to_sql) { is_expected.to eq('users.created_at') }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { Time.parse('01/01/2021 10:00 +0000').in_time_zone }

    it { is_expected.to eq('January, 2021') }
  end
end
