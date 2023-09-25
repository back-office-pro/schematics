# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::MigrationAbility do
  subject(:ability) { described_class.new }

  let(:state) { :pending }
  let(:migration) { Migration.new(state:) }

  it { is_expected.not_to be_able_to(:import, Migration) }
  it { is_expected.not_to be_able_to(:update, migration) }
  it { is_expected.not_to be_able_to(:migrate, migration) }
  it { is_expected.not_to be_able_to(:rollback, migration) }

  context 'when the migration is in progress' do
    let(:state) { :in_progress }

    it { is_expected.not_to be_able_to(:update, migration) }
    it { is_expected.not_to be_able_to(:archive, migration) }
  end

  context 'when the migration is finished' do
    let(:state) { :finished }

    it { is_expected.not_to be_able_to(:update, migration) }
  end
end
