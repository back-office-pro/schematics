# frozen_string_literal: true

describe Schematics::Migration do # rubocop:disable RSpec/MultipleMemoizedHelpers
  subject { described_class.new(schema:, type:, entity:, attribute:, timestamp:) }

  let(:schema) { Schematics::Schema.instance }
  let(:type) { 'remove_attribute' }
  let(:entity) { 'user' }
  let(:attribute) { 'locale' }
  let(:timestamp) { 20_230_515_130_024 }
  let(:application_record_class_double) do
    class_double('ApplicationRecord').as_stubbed_const # rubocop:disable RSpec/VerifiedDoubleReference
  end

  before do
    allow(application_record_class_double)
      .to receive_message_chain( # rubocop:disable RSpec/MessageChain
        :connection,
        :migration_context,
        :current_version
      ).and_return(20_230_515_130_025)
  end

  it { is_expected.to be_migrated }
end
