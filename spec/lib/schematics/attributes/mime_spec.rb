# frozen_string_literal: true

describe Schematics::Attributes::Mime do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'active_storage/attachment') }
  let(:name) { 'content_type' }
  let(:options) { {} }

  before do
    allow(Mime::EXTENSION_LOOKUP)
      .to receive(:values)
      .and_return([Mime::Type.lookup('image/png')])
  end

  it { is_expected.to be_a(Schematics::Behaviours::Identifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Listable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Enumerable) }

  its(:database_type) { is_expected.to eq('string') }
  its(:column_name) { is_expected.to eq('content_type') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:file) }
  its(:default) { is_expected.to eq('image/png') }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('active_storage_attachments.content_type') }
  its(:to_s) { is_expected.to eq('schema:active_storage_attachment_content_type') }
  its(:collection) { is_expected.to eq([['PNG', 'image/png']]) }

  its(:validators) do
    is_expected.to eq(inclusion: { in: ['image/png'] }, allow_blank: true)
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :content_type, {:inclusion=>{:in=>["image/png"]}, :allow_blank=>true}
    RUBY
  end

  describe '#format' do
    subject { attribute.format(value) }

    let(:value) { 'image/png' }

    it { is_expected.to eq('PNG') }
  end
end
