# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Attributes::Uuid do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:schema) { Schematics::Schema.new(name: 'demo') }
  let(:entity) { Schematics::Entities::Entity.new(schema:, name: 'entity') }
  let(:name) { 'id' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }

  its(:database_type) { is_expected.to eq('uuid') }
  its(:column_name) { is_expected.to eq('id') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:default) { is_expected.to be_a(String) }
  its(:icon) { is_expected.to eq(:id_card) }
  its(:validators) { is_expected.to be_empty }
  its(:to_spec) { is_expected.to eq('A entity has a **id** attribute of type *uuid*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.entity.id') }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached
    )
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class) }
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { '22ev1t77qd9ztb67njc6drsf72' }

    it { is_expected.to eq('22ev1t77qd9ztb67njc6drsf72') }
  end
end
