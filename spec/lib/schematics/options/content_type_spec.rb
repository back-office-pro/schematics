# frozen_string_literal: true

describe Schematics::Options::ContentType do
  subject { described_class }

  before do
    allow(Mime::LOOKUP).to receive(:values).and_return([Mime[:png]])
  end

  its(:name) { is_expected.to eq(:content_type) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq(['png']) }

  it { is_expected.to be_multiple }
end
