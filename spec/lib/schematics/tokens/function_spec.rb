# frozen_string_literal: true

describe Schematics::Tokens::Function do
  subject(:token) { described_class.new(value) }

  context 'when function is now' do
    let(:value) { 'NOW()' }

    its(:to_sql) { is_expected.to eq('NOW()') }
    its(:value) { is_expected.to eq('Time.current') }
  end
end
