describe Schematics::Tokens::Tokenizer do
  subject(:tokenizer) { described_class }

  describe '.tokenize' do
    subject { tokenizer.tokenize(function, table_name) }

    let(:table_name) { 'users' }

    context 'when function is a concatenation' do
      let(:function) { 'welcome $first_name $last_name' }

      its(:first) { is_expected.to be_a(Schematics::Tokens::String) }
      its(:second) { is_expected.to be_a(Schematics::Tokens::Whitespace) }
      its(:third) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its(:fourth) { is_expected.to be_a(Schematics::Tokens::Whitespace) }
      its(:fifth) { is_expected.to be_a(Schematics::Tokens::Variable) }
    end

    context 'when function is a calculation' do
      let(:function) { '($price + 2)' }

      its(:first) { is_expected.to be_a(Schematics::Tokens::Parenthesis) }
      its(:second) { is_expected.to be_a(Schematics::Tokens::Variable) }
      its(:third) { is_expected.to be_a(Schematics::Tokens::Operator) }
      its(:fourth) { is_expected.to be_a(Schematics::Tokens::Number) }
      its(:fifth) { is_expected.to be_a(Schematics::Tokens::Parenthesis) }
    end
  end
end
