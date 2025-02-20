# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

describe Schematics::Triggers::Errors::NameError do
  subject(:error) { described_class.new(exception) }

  let(:exception) { NameError.new(nil, 'foo') }

  its(:to_s) { is_expected.to eq('foo is not defined') }
end
