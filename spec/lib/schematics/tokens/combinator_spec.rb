# frozen_string_literal: true

describe Schematics::Tokens::Combinator do
  subject(:token) { described_class.new(value) }

  context 'when combinator is AND' do
    let(:value) { ' && ' }

    its(:to_sql) { is_expected.to eq(' AND ') }
    its(:to_str) { is_expected.to eq(' && ') }
  end

  context 'when combinator is OR' do
    let(:value) { ' || ' }

    its(:to_sql) { is_expected.to eq(' OR ') }
    its(:to_str) { is_expected.to eq(' || ') }
  end
end
