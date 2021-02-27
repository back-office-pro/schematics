require 'schematics/tokens/whitespace'

describe Schematics::Tokens::Whitespace do
  subject(:token) { described_class.new }

  its(:value) { is_expected.to eq(' ') }
  its(:to_sql) { is_expected.to eq("' '") }
  its(:to_str) { is_expected.to eq(' ') }
end
