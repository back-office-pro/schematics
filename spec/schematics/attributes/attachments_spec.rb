# frozen_string_literal: true

require 'schematics/attributes/attachments'
require 'schematics/entities/entity'

describe Schematics::Attributes::Attachments do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.create(name: 'directory') }
  let(:name) { 'files' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:type) { is_expected.to eq('attachments') }
  its(:column_name) { is_expected.to eq('files') }
  its(:icon) { is_expected.to eq(:file_image) }
  its(:default) { is_expected.to be_all(Rack::Test::UploadedFile) }
  its(:validators) { is_expected.to be_empty }
  its(:validate) { is_expected.to be_nil }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('directories.files') }
  its(:to_s) { is_expected.to eq('schema:directory_files') }
  its(:preload) { is_expected.to eq({ files_attachments: [blob: :variant_records] }) }
  its(:extension) { is_expected.to eq('png') }
  it { is_expected.to be_image }

  its(:permitted_params) do
    is_expected.to eq(
      [
        { files: [] },
        { files_attachments_attributes: %i[id _destroy] },
      ]
    )
  end

  its(:permitted_json_params) do
    is_expected.to eq(
      [
        { files: [] },
        { files_attachments_attributes: %i[id _destroy] },
      ]
    )
  end

  its(:search_data) do
    is_expected.to eq <<~RUBY
      files.map(&:filename).map(&:to_s).map(&:downcase)
    RUBY
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_many_base64_attached :files
      accepts_nested_attributes_for :files_attachments,
                                    allow_destroy: true,
                                    reject_if: :all_blank
    RUBY
  end

  context 'when attachment is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }
    its(:validators) { is_expected.to eq({ presence: true, attached: true }) }

    its(:validate) do
      is_expected.to eq <<~RUBY
        validates :files, {:presence=>true, :attached=>true}
      RUBY
    end
  end
end
