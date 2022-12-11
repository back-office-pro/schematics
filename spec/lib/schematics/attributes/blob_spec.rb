# frozen_string_literal: true

describe Schematics::Attributes::Blob do
  subject(:attribute) { described_class.new(entity:, name:, options:) }

  let(:entity) { Schematics::Entities::Entity.new(name: 'active_storage/attachment') }
  let(:name) { 'blob' }
  let(:options) { {} }

  its(:preload) { is_expected.to eq(blob: :variant_records) }
  its(:search_column) { is_expected.to eq(:blob_blob_filename) }
  its(:search_predicate) { is_expected.to eq(:i_cont) }
  its(:search_query) { is_expected.to eq(:blob_blob_filename_i_cont) }
  its(:to_str) { is_expected.to be_blank }
end
