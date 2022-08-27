# frozen_string_literal: true

describe Schematics::Virtuals::Errors::ArgumentError do
  subject(:error) { described_class.new(exception) }

  let(:exception) { ArgumentError.new }

  its(:to_s) { is_expected.to eq('a virtual cannot contains an assignment') }
end
