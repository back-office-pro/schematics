# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::SchemaDatasetAbility do
  subject(:ability) { described_class.new }

  let(:state) { :pending }
  let(:schema_dataset) { SchemaDataset.new(state:) }

  it { is_expected.not_to be_able_to(:import, SchemaDataset) }

  context 'when the migration is in progress' do
    let(:state) { :in_progress }

    it { is_expected.not_to be_able_to(:manage, schema_dataset) }
  end

  context 'when the migration is done' do
    let(:state) { :migrated }

    it { is_expected.not_to be_able_to(:update, schema_dataset) }
  end
end
