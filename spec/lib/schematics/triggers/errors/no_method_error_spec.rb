# frozen_string_literal: true

describe Schematics::Triggers::Errors::NoMethodError do
  subject(:error) { described_class.new(exception) }

  let(:exception) { NoMethodError.new(nil, 'foo_formatted', receiver:) }
  let(:receiver) { nil }

  its(:name) { is_expected.to eq('foo') }

  context 'when there is no receiver' do
    its(:to_s) { is_expected.to eq('a variable does not have value') }
  end

  context 'when there is a receiver' do
    let(:receiver) { 'bar' }

    its(:to_s) { is_expected.to eq('foo is not defined') }
  end
end
