# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Components::Parameter do
  subject { described_class.new(name:, in:, type:, description:) }

  let(:name) { 'page' }
  let(:type) { 'integer' }
  let(:in) { 'query' }
  let(:description) { 'Current page' }
  let(:expected_hash) do
    {
      description:,
      in:,
      name:,
      required: false,
      schema: { description:, type: }
    }
  end

  its(:to_h) { is_expected.to eq(expected_hash) }

  describe '.id' do
    subject { described_class.id }

    let(:expected_hash) do
      {
        in: 'path',
        name: 'id',
        required: false,
        schema: { type: 'string' }
      }
    end

    its(:to_h) { is_expected.to eq(expected_hash) }
  end
end
