# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Attributes::Attachment do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'avatar' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }

  its(:database_type) { is_expected.to eq('attachment') }
  its(:column_name) { is_expected.to eq('avatar') }
  its(:open_api_body_type) { is_expected.to eq('file') }
  its(:open_api_schema_type) { is_expected.to eq('string') }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:icon) { is_expected.to eq(:file) }
  its(:default) { is_expected.to be_a(Rack::Test::UploadedFile) }
  its(:validators) { is_expected.to eq(storage_quota: true) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('active_storage_blobs.filename') }
  its(:to_s) { is_expected.to eq('avatar:attachment') }
  its(:preload) { is_expected.to eq([avatar_attachment: [blob: :variant_records]]) }
  its(:includes) { is_expected.to eq(blob: :variant_records) }
  its(:extension) { is_expected.to be_nil }
  its(:input_name) { is_expected.to eq('user[avatar]') }
  its(:search_column) { is_expected.to eq(:avatar_blob_filename) }
  its(:search_column_association) { is_expected.to eq('avatar_blob') }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:avatar_i_cont) }
  its(:to_spec) { is_expected.to eq('A user has a **avatar** attribute of type *attachment*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.user.avatar') }
  it { is_expected.not_to be_image }

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Readonly,
      Schematics::Options::Size,
      Schematics::Options::AspectRatio,
      Schematics::Options::Width,
      Schematics::Options::Height,
      Schematics::Options::ContentType
    )
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :avatar, {storage_quota: true}
    RUBY
  end

  its(:permitted_params) do
    is_expected.to eq(
      [
        :avatar,
        { avatar_attachment_attributes: %i[id _destroy] }
      ]
    )
  end

  its(:permitted_json_params) do
    is_expected.to eq(
      [
        { avatar: %i[data filename content_type] },
        { avatar_attachment_attributes: %i[id _destroy] }
      ]
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_one_base64_attached :avatar
      accepts_nested_attributes_for :avatar_attachment,
                                    allow_destroy: true,
                                    reject_if: :all_blank
    RUBY
  end

  context 'when attachment is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }

    its(:validators) do
      is_expected.to eq(attached: true, storage_quota: true)
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :avatar, {attached: true, storage_quota: true}
      RUBY
    end
  end

  context 'when size option is defined' do
    let(:options) { { size: 10 } }

    its(:validators) do
      is_expected.to eq(storage_quota: true, size: { less_than: 10.megabytes })
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :avatar, {storage_quota: true, size: {less_than: 10485760}}
      RUBY
    end
  end

  context 'when aspect_ratio option is defined' do
    let(:options) { { aspect_ratio: 10 } }

    its(:validators) do
      is_expected.to eq(storage_quota: true, aspect_ratio: 10)
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :avatar, {storage_quota: true, aspect_ratio: 10}
      RUBY
    end
  end

  context 'when content_type option is defined' do
    let(:options) { { content_type: ['image/png', 'image/jpeg'] } }

    it { is_expected.to be_image }
    its(:extension) { is_expected.to eq(:png) }
    its(:icon) { is_expected.to eq(:file_image) }

    its(:validators) do
      is_expected.to eq(
        storage_quota: true,
        content_type: {
          with: ['image/png', 'image/jpeg'],
          spoofing_protection: true
        }
      )
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :avatar, {storage_quota: true, content_type: {with: ["image/png", "image/jpeg"], spoofing_protection: true}}
      RUBY
    end
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class, Schematics::Attributes::Attachments) }
  end
end
