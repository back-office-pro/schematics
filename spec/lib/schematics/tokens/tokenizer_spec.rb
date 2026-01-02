# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

describe Schematics::Tokens::Tokenizer do
  subject(:tokenizer) { described_class }

  describe '.tokenize' do
    subject { tokenizer.tokenize(function, table_name) }

    let(:table_name) { 'users' }

    context 'when function is a concatenation' do
      let(:function) { 'welcome $first_name $last_name' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::String) }
      its([0]) { is_expected.to have_attributes(value: 'welcome') }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Whitespace) }
      its([1]) { is_expected.to have_attributes(value: ' ') }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([2]) { is_expected.to have_attributes(value: 'self.first_name') }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Whitespace) }
      its([3]) { is_expected.to have_attributes(value: ' ') }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([4]) { is_expected.to have_attributes(value: 'self.last_name') }
    end

    context 'when function is a calculation' do
      let(:function) { '($price + 2)' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Parenthesis) }
      its([0]) { is_expected.to have_attributes(value: '(') }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([1]) { is_expected.to have_attributes(value: 'self.price') }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Operator) }
      its([2]) { is_expected.to have_attributes(value: ' + ') }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([3]) { is_expected.to have_attributes(value: '2') }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Parenthesis) }
      its([4]) { is_expected.to have_attributes(value: ')') }
    end

    context 'when function is a comparison' do
      let(:function) { '$price >= 100 && $vat != 20' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([0]) { is_expected.to have_attributes(value: 'self.price') }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([1]) { is_expected.to have_attributes(value: ' >= ') }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([2]) { is_expected.to have_attributes(value: '100') }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Combinator) }
      its([3]) { is_expected.to have_attributes(value: ' && ') }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([4]) { is_expected.to have_attributes(value: 'self.vat') }
      its([5]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([5]) { is_expected.to have_attributes(value: ' != ') }
      its([6]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([6]) { is_expected.to have_attributes(value: '20') }
    end

    context 'when function is a not spaced comparison' do
      let(:function) { '$price>=100&&$vat!=20' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([0]) { is_expected.to have_attributes(value: 'self.price') }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([1]) { is_expected.to have_attributes(value: '>=') }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([2]) { is_expected.to have_attributes(value: '100') }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Combinator) }
      its([3]) { is_expected.to have_attributes(value: '&&') }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([4]) { is_expected.to have_attributes(value: 'self.vat') }
      its([5]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([5]) { is_expected.to have_attributes(value: '!=') }
      its([6]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([6]) { is_expected.to have_attributes(value: '20') }
    end

    context 'when function is a more complex comparison' do
      let(:function) { '$expires_at == NULL || NOW() < $expires_at' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([0]) { is_expected.to have_attributes(value: 'self.expires_at') }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([1]) { is_expected.to have_attributes(value: ' == nil ') }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Combinator) }
      its([2]) { is_expected.to have_attributes(value: '|| ') }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Function) }
      its([3]) { is_expected.to have_attributes(value: 'Time.current') }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([4]) { is_expected.to have_attributes(value: ' < ') }
      its([5]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([5]) { is_expected.to have_attributes(value: 'self.expires_at') }
    end

    context 'when function is a not spaced more complex comparison' do
      let(:function) { '$expires_at==NULL||NOW()<$expires_at' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([0]) { is_expected.to have_attributes(value: 'self.expires_at') }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([1]) { is_expected.to have_attributes(value: ' == nil ') }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Combinator) }
      its([2]) { is_expected.to have_attributes(value: '||') }
      its([3]) { is_expected.to be_a(Schematics::Tokens::Function) }
      its([3]) { is_expected.to have_attributes(value: 'Time.current') }
      its([4]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([4]) { is_expected.to have_attributes(value: '<') }
      its([5]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([5]) { is_expected.to have_attributes(value: 'self.expires_at') }
    end

    context 'when function is an assignment' do
      let(:function) { '$in_stock = true' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([0]) { is_expected.to have_attributes(value: 'self.in_stock') }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Assignment) }
      its([1]) { is_expected.to have_attributes(value: ' = ') }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Boolean) }
      its([2]) { is_expected.to have_attributes(value: 'true') }
    end

    context 'when function is a not spaced assignment' do
      let(:function) { '$in_stock=true' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([0]) { is_expected.to have_attributes(value: 'self.in_stock') }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Assignment) }
      its([1]) { is_expected.to have_attributes(value: '=') }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Boolean) }
      its([2]) { is_expected.to have_attributes(value: 'true') }
    end

    context 'when function has a negative number' do
      let(:function) { '$price > -1' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([0]) { is_expected.to have_attributes(value: 'self.price') }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([1]) { is_expected.to have_attributes(value: ' > ') }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([2]) { is_expected.to have_attributes(value: '-1') }
    end

    context 'when function is not spaced and has a negative number' do
      let(:function) { '$price>-1' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its([0]) { is_expected.to have_attributes(value: 'self.price') }
      its([1]) { is_expected.to be_a(Schematics::Tokens::Comparator) }
      its([1]) { is_expected.to have_attributes(value: '>') }
      its([2]) { is_expected.to be_a(Schematics::Tokens::Number) }
      its([2]) { is_expected.to have_attributes(value: '-1') }
    end

    context 'when function is an aggregate function' do
      let(:function) { 'SUM($stock_movements.cost)' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Function) }
      its([0]) { is_expected.to have_attributes(value: 'stock_movements.sum(&:cost)') }
    end

    context 'when function is an arithmetic function' do
      let(:function) { 'ABS($cost)' }

      its([0]) { is_expected.to be_a(Schematics::Tokens::Function) }
      its([0]) { is_expected.to have_attributes(value: 'self.cost&.abs') }
    end
  end
end
