# frozen_string_literal: true

describe Schematics::Attributes::Mime do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'active_storage/attachment') }
  let(:name) { 'content_type' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('content_type') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:file) }
  its(:default) { is_expected.to eq('image/png') }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('active_storage_attachments.content_type') }
  its(:to_s) { is_expected.to eq('schema:active_storage_attachment_content_type') }

  its(:validators) do
    is_expected.to eq(
      {
        allow_blank: true,
        format: { with: Mime::Type::MIME_REGEXP, message: :mime_type }
      }
    )
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'image/png' }

    it { is_expected.to eq('PNG') }
  end
end
