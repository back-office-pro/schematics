# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OpenAPI::Components::Type do
  subject { described_class.new(value:) }

  context 'when value is date' do
    let(:value) { 'date' }

    its(:to_h) { is_expected.to eq(type: 'string', format: 'date') }
  end

  context 'when value is password' do
    let(:value) { 'password' }

    its(:to_h) { is_expected.to eq(type: 'string', format: 'password') }
  end

  context 'when value is datetime' do
    let(:value) { 'datetime' }

    its(:to_h) { is_expected.to eq(type: 'string', format: 'date-time') }
  end

  context 'when value is float' do
    let(:value) { 'float' }

    its(:to_h) { is_expected.to eq(type: 'number', format: 'float') }
  end

  context 'when value is file' do
    let(:value) { 'file' }

    its(:to_h) { is_expected.to eq(type: 'string', format: 'binary') }
  end

  context 'when value is an array' do
    let(:value) { %w[string] }

    its(:to_h) { is_expected.to eq(type: 'array', items: { type: 'string' }) }
  end

  context 'when value is a hash' do
    let(:value) { { name!: 'string' } }

    its(:to_h) do
      is_expected.to eq(
        type: 'object',
        properties: { name: { type: 'string' } },
        required: %w[name]
      )
    end
  end
end
