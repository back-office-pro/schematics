# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::MigrationAbility do
  subject(:ability) { described_class.new }

  let(:state) { Migration::STATE_STATE_EDITING }
  let(:migration) { Migration.new(state:) }

  it { is_expected.not_to be_able_to(:import, Migration) }
  it { is_expected.not_to be_able_to(:duplicate, Migration) }
  it { is_expected.not_to be_able_to(:update, migration) }
  it { is_expected.not_to be_able_to(:migrate, migration) }
  it { is_expected.not_to be_able_to(:rollback, migration) }
  it { is_expected.not_to be_able_to(:schedule, migration) }
  it { is_expected.not_to be_able_to(:unschedule, migration) }

  context 'when the migration is in progress' do
    let(:state) { Migration::STATE_STATE_IN_PROGRESS }

    it { is_expected.not_to be_able_to(:update, migration) }
    it { is_expected.not_to be_able_to(:archive, migration) }
  end

  context 'when the migration is rollbacking' do
    let(:state) { Migration::STATE_STATE_ROLLBACKING }

    it { is_expected.not_to be_able_to(:update, migration) }
    it { is_expected.not_to be_able_to(:archive, migration) }
  end

  context 'when the migration is generating' do
    let(:state) { Migration::STATE_STATE_GENERATING }

    it { is_expected.not_to be_able_to(:update, migration) }
    it { is_expected.not_to be_able_to(:archive, migration) }
  end

  context 'when the migration is finished' do
    let(:state) { Migration::STATE_STATE_FINISHED }

    it { is_expected.not_to be_able_to(:update, migration) }
  end
end
