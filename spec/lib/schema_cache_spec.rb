# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails'

describe SchemaCache do
  subject { described_class }

  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

  before { allow(Rails).to receive(:cache).and_return(memory_store) }

  its(:entities) { is_expected.to be_all(Schematics::Entities::Entity) }
end
