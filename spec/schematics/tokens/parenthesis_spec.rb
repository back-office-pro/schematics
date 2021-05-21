# frozen_string_literal: true

require 'schematics/tokens/parenthesis'

describe Schematics::Tokens::Parenthesis do
  subject(:token) { described_class.new(value) }

  let(:value) { '(' }

  its(:to_sql) { is_expected.to eq('(') }
  its(:to_str) { is_expected.to eq('(') }
end
