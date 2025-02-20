# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Tokens::Comparator do
  subject(:token) { described_class.new(value) }

  context 'when comparator is equal' do
    let(:value) { ' == ' }

    its(:to_sql) { is_expected.to eq(' = ') }
    its(:value) { is_expected.to eq(' == ') }
  end

  context 'when comparator is not equal' do
    let(:value) { ' != ' }

    its(:to_sql) { is_expected.to eq(' != ') }
    its(:value) { is_expected.to eq(' != ') }
  end

  context 'when comparator is equal NULL' do
    let(:value) { ' == NULL ' }

    its(:to_sql) { is_expected.to eq(' IS NULL') }
    its(:value) { is_expected.to eq(' == nil ') }
  end

  context 'when comparator is not equal NULL' do
    let(:value) { ' != NULL ' }

    its(:to_sql) { is_expected.to eq(' IS NOT NULL') }
    its(:value) { is_expected.to eq(' != nil ') }
  end
end
