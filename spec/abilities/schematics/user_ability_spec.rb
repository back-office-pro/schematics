# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::UserAbility do
  subject(:ability) { described_class.new(user) }

  let(:role) { Core::Role.new }
  let(:user) { Core::User.new(role:) }
  let(:permissions) { Core::Permission.create_entities_permissions! }
  let(:admin_role) { Core::Role.create!(name: 'Admin', permissions:) }

  it { is_expected.not_to be_able_to(:impersonate, Core::User) }
  it { is_expected.not_to be_able_to(:impersonate, user) }
  it { is_expected.to be_able_to(:update, user) }
  it { is_expected.not_to be_able_to(:update, user, :role) }
  it { is_expected.not_to be_able_to(:update, user, :role_id) }
  it { is_expected.not_to be_able_to(:update, user, :user_groups) }
  it { is_expected.not_to be_able_to(:update, user, :user_group_ids) }
  it { is_expected.not_to be_able_to(:destroy, user) }
  it { is_expected.not_to be_able_to(:archive, user) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:impersonate, Core::User) }
    it { is_expected.not_to be_able_to(:impersonate, user) }
  end
end
