# frozen_string_literal: true

describe Schematics::Tokens::Comparator do
  subject(:token) { described_class.new(value) }

  context 'when comparator is equal' do
    let(:value) { ' == ' }

    its(:to_sql) { is_expected.to eq(' = ') }
    its(:to_str) { is_expected.to eq(' == ') }
  end

  context 'when comparator is not equal' do
    let(:value) { ' != ' }

    its(:to_sql) { is_expected.to eq(' != ') }
    its(:to_str) { is_expected.to eq(' != ') }
  end
end
