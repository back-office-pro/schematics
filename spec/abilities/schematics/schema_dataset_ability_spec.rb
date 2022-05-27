# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::SchemaDatasetAbility do
  subject(:ability) { described_class.new }

  fixtures :schema_datasets

  let(:schema_dataset) { schema_datasets(:one) }

  before { SchemaDataset.aasm.state_machine.config.no_direct_assignment = false }

  it { is_expected.not_to be_able_to(:import, SchemaDataset) }

  context 'when the migration is pending' do
    before { schema_dataset.update!(state: :pending) }

    it { is_expected.not_to be_able_to(:destroy, schema_dataset) }
  end

  context 'when the migration is done' do
    before { schema_dataset.update!(state: :migrated) }

    it { is_expected.not_to be_able_to(:destroy, schema_dataset) }
  end
end
