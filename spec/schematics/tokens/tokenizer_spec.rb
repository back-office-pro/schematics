# frozen_string_literal: true

require 'schematics/tokens/tokenizer'

describe Schematics::Tokens::Tokenizer do
  subject(:tokenizer) { described_class }

  describe '.tokenize' do
    subject { tokenizer.tokenize(function, table_name) }

    let(:table_name) { 'users' }

    context 'when function is a concatenation' do
      let(:function) { 'welcome $first_name $last_name' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::String) }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Whitespace) }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Whitespace) }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Variable) }
    end

    context 'when function is a calculation' do
      let(:function) { '($price + 2)' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Parenthesis) }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Operator) }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Parenthesis) }
    end

    context 'when function is a not spaced calculation' do
      let(:function) { '($price+2)' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Parenthesis) }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Operator) }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Parenthesis) }
    end

    context 'when function is a comparison' do
      let(:function) { '$price >= 100 && $vat != 20' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Combinator) }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([5]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([6]) { is_expected.to be_a(Schematics::Tokens::Number) }
    end

    context 'when function is a not spaced comparison' do
      let(:function) { '$price>=100&&$vat!=20' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Combinator) }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([5]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([6]) { is_expected.to be_a(Schematics::Tokens::Number) }
    end
  end
end
