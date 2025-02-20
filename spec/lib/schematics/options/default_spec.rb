# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Options::Default do
  subject { described_class }

  its(:option_name) { is_expected.to eq(:default) }
  its(:input_type) { is_expected.to eq(:polymorphic) }
end
