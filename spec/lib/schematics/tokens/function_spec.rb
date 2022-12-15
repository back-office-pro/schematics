# frozen_string_literal: true

describe Schematics::Tokens::Function do
  subject(:token) { described_class.new(value) }

  context 'when function is NOW()' do
    let(:value) { 'NOW()' }

    its(:value) { is_expected.to eq('Time.current') }
    its(:to_sql) { is_expected.to eq('NOW()') }
    its(:to_str) { is_expected.to eq('#{Time.current}') } # rubocop:disable Lint/InterpolationCheck
  end
end
