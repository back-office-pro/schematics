# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe SchemaCache do
  describe '#fetch' do
    subject { described_class.fetch(name) }

    let(:name) { 'current' }
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

    before { allow(Rails).to receive(:cache).and_return(memory_store) }

    it { is_expected.to be_a(Schematics::Schema) }
  end
end
