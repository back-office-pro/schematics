# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Attributes::Attachments do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'directory') }
  let(:name) { 'files' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Specifiable) }
  it { is_expected.to be_a(Schematics::Behaviours::Documentable) }
  it { is_expected.to be_a(Schematics::Behaviours::Generatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Inspectable) }
  it { is_expected.to be_a(Schematics::Behaviours::Optionable) }
  it { is_expected.to be_a(Schematics::Behaviours::Nameable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }
  it { is_expected.to be_a(Schematics::Behaviours::Internationalizable) }

  its(:database_type) { is_expected.to eq('attachments') }
  its(:column_name) { is_expected.to eq('files') }
  its(:open_api_body_type) { is_expected.to eq(['file']) }
  its(:open_api_schema_type) { is_expected.to eq(['string']) }
  its(:open_api_query_type) { is_expected.to eq('string') }
  its(:icon) { is_expected.to eq(:file) }
  its(:default) { is_expected.to be_all(Rack::Test::UploadedFile) }
  its(:validators) { is_expected.to eq(antivirus: true, storage_quota: true) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('active_storage_blobs.filename') }
  its(:to_s) { is_expected.to eq('files:attachments') }
  its(:preload) { is_expected.to eq([files_attachments: [blob: :variant_records]]) }
  its(:includes) { is_expected.to eq(blob: :variant_records) }
  its(:extension) { is_expected.to be_nil }
  its(:input_name) { is_expected.to eq('directory[files][]') }
  its(:search_column) { is_expected.to eq(:files_blobs_filename) }
  its(:search_column_association) { is_expected.to eq('files_blobs') }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:files_i_cont) }
  its(:to_spec) { is_expected.to eq('A directory has a **files** attribute of type *attachments*') }
  its(:i18n_key) { is_expected.to eq('activerecord.attributes.directory.files') }
  it { is_expected.not_to be_image }

  its(:openai_description) do
    is_expected.to eq('An attribute which represents a set of attachments')
  end

  its(:available_options) do
    is_expected.to contain_exactly(
      Schematics::Options::Group,
      Schematics::Options::Required,
      Schematics::Options::Hidden,
      Schematics::Options::Cached,
      Schematics::Options::Readonly,
      Schematics::Options::Size,
      Schematics::Options::AspectRatio,
      Schematics::Options::Min,
      Schematics::Options::Max,
      Schematics::Options::Width,
      Schematics::Options::Height,
      Schematics::Options::ContentType
    )
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :files, {:antivirus=>true, :storage_quota=>true}
    RUBY
  end

  its(:permitted_params) do
    is_expected.to eq(
      [
        { files: [] },
        { files_attachments_attributes: %i[id _destroy] }
      ]
    )
  end

  its(:permitted_json_params) do
    is_expected.to eq(
      [
        { files: [] },
        { files_attachments_attributes: %i[id _destroy] }
      ]
    )
  end

  its(:to_str) do
    is_expected.to eq <<~RUBY
      has_many_base64_attached :files, strict_loading: true
      accepts_nested_attributes_for :files_attachments,
                                    allow_destroy: true,
                                    reject_if: :all_blank
    RUBY
  end

  its(:to_openai_schema) do
    is_expected.to eq(
      attachments: {
        type: 'object',
        additionalProperties: false,
        required: %w[name type options],
        properties: {
          type: {
            type: 'string',
            description: 'An attribute which represents a set of attachments',
            enum: %w[attachments]
          },
          name: { '$ref': '#/$defs/name' },
          options: {
            type: 'object',
            additionalProperties: false,
            anyOf: [
              { '$ref': '#/$defs/required' },
              { '$ref': '#/$defs/readonly' },
              { '$ref': '#/$defs/size' },
              { '$ref': '#/$defs/aspect_ratio' },
              { '$ref': '#/$defs/width' },
              { '$ref': '#/$defs/height' },
              { '$ref': '#/$defs/content_type' },
              { '$ref': '#/$defs/min' },
              { '$ref': '#/$defs/max' }
            ]
          }
        }
      }
    )
  end

  context 'when attachment is required' do
    let(:options) { { required: true } }

    it { is_expected.to be_required }

    its(:validators) do
      is_expected.to eq(attached: true, antivirus: true, storage_quota: true)
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :files, {:attached=>true, :antivirus=>true, :storage_quota=>true}
      RUBY
    end
  end

  context 'when min option is defined' do
    let(:options) { { min: 1 } }

    its(:validators) do
      is_expected.to eq(antivirus: true, storage_quota: true, limit: { min: 1 })
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :files, {:antivirus=>true, :storage_quota=>true, :limit=>{:min=>1}}
      RUBY
    end
  end

  context 'when max option is defined' do
    let(:options) { { max: 1 } }

    its(:validators) do
      is_expected.to eq(antivirus: true, storage_quota: true, limit: { max: 1 })
    end

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :files, {:antivirus=>true, :storage_quota=>true, :limit=>{:max=>1}}
      RUBY
    end
  end

  describe '.compatible_types' do
    subject { described_class.compatible_types }

    it { is_expected.to contain_exactly(described_class, Schematics::Attributes::Attachment) }
  end
end
