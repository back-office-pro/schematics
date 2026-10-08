# frozen_string_literal: true

describe Schematics::Tokens::Operator do
  subject(:token) { described_class.new(value) }

  context 'when operator is plus' do
    let(:value) { ' + ' }

    its(:to_sql) { is_expected.to eq(' + ') }
    its(:to_str) { is_expected.to eq(' + ') }
  end

  context 'when operator is minus' do
    let(:value) { ' - ' }

    its(:to_sql) { is_expected.to eq(' - ') }
    its(:to_str) { is_expected.to eq(' - ') }
  end

  context 'when operator is left shift' do
    let(:value) { ' << ' }

    its(:to_sql) { is_expected.to eq(' << ') }
    its(:to_str) { is_expected.to eq(' << ') }
  end

  context 'when operator is right shift' do
    let(:value) { ' >> ' }

    its(:to_sql) { is_expected.to eq(' >> ') }
    its(:to_str) { is_expected.to eq(' >> ') }
  end
end
