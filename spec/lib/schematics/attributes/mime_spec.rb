# frozen_string_literal: true

describe Schematics::Attributes::Mime do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'active_storage/attachment') }
  let(:name) { 'content_type' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Editable) }

  its(:type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('content_type') }
  its(:open_api_type) { is_expected.to eq(:string) }
  its(:icon) { is_expected.to eq(:file) }
  its(:input_type) { is_expected.to eq(:input) }
  its(:default) { is_expected.to be_nil }
  its(:validators) { is_expected.to be_empty }
  its(:validate) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('active_storage_attachments.content_type') }
  its(:to_s) { is_expected.to eq('schema:active_storage_attachment_content_type') }

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'image/png' }

    it { is_expected.to eq('PNG') }
  end
end
