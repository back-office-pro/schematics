# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Triggers::Errors::TypeError do
  subject(:error) { described_class.new(exception) }

  let(:exception) { TypeError.new('no implicit conversion of String into Integer') }

  its(:to_s) { is_expected.to eq('conversion from string to integer') }
end
