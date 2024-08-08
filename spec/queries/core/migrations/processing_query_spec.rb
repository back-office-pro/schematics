# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Migrations::ProcessingQuery do
  let(:first_migration) { Migration.create!(state: Migration::STATE_STATE_PENDING) }
  let(:second_migration) { Migration.create!(state: Migration::STATE_STATE_IN_PROGRESS) }
  let(:third_migration) { Migration.create!(state: Migration::STATE_STATE_ROLLBACKING) }
  let(:fourth_migration) { Migration.create!(state: Migration::STATE_STATE_GENERATING) }
  let(:fifth_migration) { Migration.create!(state: Migration::STATE_STATE_FINISHED) }

  before do
    first_migration
    second_migration
    third_migration
    fourth_migration
    fifth_migration
  end

  its(:call) do
    is_expected.to contain_exactly(
      first_migration,
      second_migration,
      third_migration,
      fourth_migration
    )
  end
end
