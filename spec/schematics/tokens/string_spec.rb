require 'schematics/tokens/string'

describe Schematics::Tokens::String do
  subject(:token) { described_class.new(value) }

  let(:value) { 'type' }

  its(:to_sql) { is_expected.to eq("'type'") }
  its(:to_str) { is_expected.to eq('type') }
end
