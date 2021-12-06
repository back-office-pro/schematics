# frozen_string_literal: true

describe Schematics::Attributes::Blob do
  subject(:attribute) { described_class.new(entity, name, options) }

  let(:entity) { Schematics::Entities::Entity.build(name: 'active_storage/attachment') }
  let(:name) { 'blob' }
  let(:options) { {} }

  its(:preload) { is_expected.to eq(blob: :variant_records) }
  its(:to_str) { is_expected.to be_blank }

  its(:search_data) do
    is_expected.to eq <<~RUBY
      blob&.filename&.to_s
    RUBY
  end
end
