# frozen_string_literal: true

require 'schematics/tokens/operator'

describe Schematics::Tokens::Operator do
  subject(:token) { described_class.new(value) }

  context 'when comparator is plus' do
    let(:value) { ' + ' }

    its(:to_sql) { is_expected.to eq(' + ') }
    its(:to_str) { is_expected.to eq(' + ') }
  end

  context 'when comparator is power' do
    let(:value) { ' ** ' }

    its(:to_sql) { is_expected.to eq(' ^ ') }
    its(:to_str) { is_expected.to eq(' ** ') }
  end
end
