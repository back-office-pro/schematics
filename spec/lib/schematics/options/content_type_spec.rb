# frozen_string_literal: true

describe Schematics::Options::ContentType do
  subject { described_class }

  its(:name) { is_expected.to eq(:content_type) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq(Mime::LOOKUP.values.map(&:symbol).map(&:to_s)) }

  it { is_expected.to be_multiple }
end
