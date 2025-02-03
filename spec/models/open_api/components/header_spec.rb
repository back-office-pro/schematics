# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Components::Header do
  subject { described_class.new(name:, type:, description:) }

  let(:name) { 'page-items' }
  let(:type) { 'integer' }
  let(:description) { 'Items per page' }
  let(:expected_hash) do
    {
      'page-items': {
        description:,
        schema: { type: }
      }
    }
  end

  its(:to_h) { is_expected.to eq(expected_hash) }
end
