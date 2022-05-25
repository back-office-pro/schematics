# frozen_string_literal: true

describe Schematics::Attributes::Decimal do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:compare_checks) { ActiveModel::Validations::Comparability::COMPARE_CHECKS.keys }
  let(:entity) { Schematics::Entities::Entity.new(name: 'entity') }
  let(:name) { 'price' }
  let(:options) do
    {
      unit: '$'
    }
  end

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }

  its(:database_type) { is_expected.to eq('decimal') }
  its(:column_name) { is_expected.to eq('price') }
  its(:open_api_type) { is_expected.to eq(Float) }
  its(:unit) { is_expected.to eq('$') }
  its(:validators) { is_expected.to eq(numericality: { allow_blank: true }) }
  its(:icon) { is_expected.to eq(:arrow_up_1_9) } # rubocop:disable Naming/VariableNumber
  its(:available_options) { is_expected.to include(*compare_checks, :unit, :precision, :scale) }

  context 'when decimal has precision' do
    let(:options) { { precision: 2 } }

    its(:options_for_migration) { is_expected.to eq(precision: 2) }

    its(:validators) do
      is_expected.to eq(numericality: { allow_blank: true, greater_than: -100, less_than: 100 })
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :price, {:numericality=>{:allow_blank=>true, :greater_than=>-100, :less_than=>100}}
      RUBY
    end
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { '100.02' }

    it { is_expected.to eq('$100.02') }
  end
end
