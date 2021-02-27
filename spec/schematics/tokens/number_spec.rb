require 'schematics/tokens/number'

describe Schematics::Tokens::Number do
  subject(:token) { described_class.new(value) }

  let(:value) { '3' }

  its(:to_sql) { is_expected.to eq('3') }
  its(:to_str) { is_expected.to eq('3') }
end
