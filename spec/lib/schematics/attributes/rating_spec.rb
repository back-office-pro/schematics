# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Attributes::Rating do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'product') }
  let(:name) { 'rating' }
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
  it { is_expected.to be_a(Schematics::Behaviours::Numerable) }
  it { is_expected.to be_a(Schematics::Behaviours::Unincrementable) }
  it { is_expected.not_to be_auto_increment }

  its(:database_type) { is_expected.to eq('float') }
  its(:column_name) { is_expected.to eq('rating') }
  its(:open_api_body_type) { is_expected.to eq('float') }
  its(:open_api_schema_type) { is_expected.to eq('float') }
  its(:open_api_query_type) { is_expected.to eq('float') }
  its(:input_name) { is_expected.to eq('product[rating]') }
  its(:validators) { is_expected.to eq(numericality: { allow_blank: true, in: 0..5 }) }
  its(:icon) { is_expected.to eq(:star) }
  its(:to_spec) { is_expected.to eq('A product has a **rating** attribute of type *rating*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.product.rating') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Default,
      Schematics::Options::Readonly,
      Schematics::Options::GreaterThan,
      Schematics::Options::GreaterThanOrEqualTo,
      Schematics::Options::EqualTo,
      Schematics::Options::LessThan,
      Schematics::Options::LessThanOrEqualTo,
      Schematics::Options::OtherThan,
      Schematics::Options::Precision,
      Schematics::Options::Separator
    )
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :rating, {:numericality=>{:allow_blank=>true, :in=>0..5}}
    RUBY
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    let(:expected_compatible_types) do
      [
        described_class,
        Schematics::Attributes::Float,
        Schematics::Attributes::Currency,
        Schematics::Attributes::Percentage,
        Schematics::Attributes::Byte
      ]
    end

    it { is_expected.to match_array(expected_compatible_types) }
  end
end
