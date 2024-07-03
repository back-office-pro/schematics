# frozen_string_literal: true

describe Schematics::Tokens::Function do
  subject(:token) { described_class.new(value) }

  context 'when function is NOW()' do
    let(:value) { 'NOW()' }

    its(:value) { is_expected.to eq('Time.current') }
    its(:to_sql) { is_expected.to eq('NOW()') }
    its(:to_str) { is_expected.to eq('#{Time.current}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is RAND()' do
    let(:value) { 'RAND()' }

    its(:value) { is_expected.to eq('rand') }
    its(:to_sql) { is_expected.to eq('RAND()') }
    its(:to_str) { is_expected.to eq('#{rand}') } # rubocop:disable Lint/InterpolationCheck
  end
end
