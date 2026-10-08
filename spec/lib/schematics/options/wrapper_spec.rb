# frozen_string_literal: true

describe Schematics::Options::Wrapper do
  subject(:wrapper) { described_class.new(options:) }

  let(:options) do
    {
      hidden: true,
      cached: true,
      limit: 10
    }
  end

  it { is_expected.to be_hidden }
  it { is_expected.to be_cached }

  its(:limit) { is_expected.to eq(10) }
end
