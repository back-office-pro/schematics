# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::ContentType do
  subject { described_class }

  before do
    allow(Mime::LOOKUP).to receive(:keys).and_return(['image/png'])
  end

  its(:option_name) { is_expected.to eq(:content_type) }
  its(:input_type) { is_expected.to eq(:select) }
  its(:collection) { is_expected.to eq(['image/png']) }
  its(:controller) { is_expected.to eq('dropdown') }

  it { is_expected.to be_multiple }
end
