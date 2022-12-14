# frozen_string_literal: true

describe Schematics::Tokens::Function do
  subject(:token) { described_class.new(value) }

  context 'when function is CURRENT_TIMESTAMP()' do
    let(:value) { 'CURRENT_TIMESTAMP()' }

    its(:value) { is_expected.to eq('Time.current') }
    its(:to_sql) { is_expected.to eq('CURRENT_TIMESTAMP()') }
    its(:to_str) { is_expected.to eq('#{Time.current}') } # rubocop:disable Lint/InterpolationCheck
  end

  context 'when function is CURRENT_DATE()' do
    let(:value) { 'CURRENT_DATE()' }

    its(:value) { is_expected.to eq('Date.current') }
    its(:to_sql) { is_expected.to eq('CURRENT_DATE()') }
    its(:to_str) { is_expected.to eq('#{Date.current}') } # rubocop:disable Lint/InterpolationCheck
  end
end
