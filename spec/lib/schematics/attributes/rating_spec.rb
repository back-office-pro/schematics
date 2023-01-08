# frozen_string_literal: true

describe Schematics::Attributes::Rating do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'product') }
  let(:name) { 'rating' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Identifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Rangeable) }
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }

  its(:database_type) { is_expected.to eq('float') }
  its(:column_name) { is_expected.to eq('rating') }
  its(:open_api_type) { is_expected.to eq(Float) }
  its(:validators) { is_expected.to eq(numericality: { allow_blank: true, in: 0..5 }) }
  its(:icon) { is_expected.to eq(:star) }

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :rating, {:numericality=>{:allow_blank=>true, :in=>0..5}}
    RUBY
  end
end
