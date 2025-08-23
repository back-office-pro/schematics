# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Server do
  subject { described_class }

  it { is_expected.not_to be_ssl }

  its(:domain) { is_expected.to eq('localhost') }
end
