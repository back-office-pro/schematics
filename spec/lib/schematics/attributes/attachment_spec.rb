# frozen_string_literal: true

describe Schematics::Attributes::Attachment do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'user') }
  let(:name) { 'avatar' }
  let(:options) { {} }

  it { is_expected.to be_a(Schematics::Behaviours::Migratable) }
  it { is_expected.to be_a(Schematics::Behaviours::Validatable) }
  it { is_expected.to be_a(Schematics::Behaviours::Renderable) }
  it { is_expected.to be_a(Schematics::Behaviours::Searchable) }
  it { is_expected.to be_a(Schematics::Behaviours::Preloadable) }
  it { is_expected.to be_a(Schematics::Behaviours::Fillable) }

  its(:database_type) { is_expected.to eq('attachment') }
  its(:column_name) { is_expected.to eq('avatar') }
  its(:open_api_type) { is_expected.to eq(String) }
  its(:icon) { is_expected.to eq(:file_image) }
  its(:default) { is_expected.to be_a(Rack::Test::UploadedFile) }
  its(:validators) { is_expected.to eq(antivirus: true) }
  its(:weight) { is_expected.to eq(1) }
  its(:to_sql) { is_expected.to eq('users.avatar') }
  its(:to_s) { is_expected.to eq('schema:user_avatar') }
  its(:preload) { is_expected.to eq(avatar_attachment: [blob: :variant_records]) }
  its(:extension) { is_expected.to eq('png') }
  it { is_expected.to be_image }

  its(:available_options) do
    is_expected.to include(:size, :aspect_ratio, :min, :max, :width, :height, :content_type)
  end

  its('validators.to_str') do
    is_expected.to eq <<~RUBY
      validates :avatar, {:antivirus=>true}
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

  its(:search_data) do
    is_expected.to eq <<~RUBY
      avatar: (avatar.filename.to_s if avatar.attached?)
    RUBY
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
    its(:validators) { is_expected.to eq(presence: true, antivirus: true, attached: true) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :avatar, {:presence=>true, :antivirus=>true, :attached=>true}
      RUBY
    end
  end

  context 'when size option is defined' do
    let(:options) { { size: 10 } }

    its(:validators) { is_expected.to eq(antivirus: true, size: { less_than: 10.megabytes }) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :avatar, {:antivirus=>true, :size=>{:less_than=>10485760}}
      RUBY
    end
  end

  context 'when aspect_ratio option is defined' do
    let(:options) { { aspect_ratio: 10 } }

    its(:validators) { is_expected.to eq(antivirus: true, aspect_ratio: 10) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :avatar, {:antivirus=>true, :aspect_ratio=>10}
      RUBY
    end
  end

  context 'when content_type option is defined' do
    let(:options) { { content_type: %w[png jpg jpeg] } }

    its(:validators) { is_expected.to eq(antivirus: true, content_type: %i[png jpg jpeg]) }

    its('validators.to_str') do
      is_expected.to eq <<~RUBY
        validates :avatar, {:antivirus=>true, :content_type=>[:png, :jpg, :jpeg]}
      RUBY
    end
  end
end
