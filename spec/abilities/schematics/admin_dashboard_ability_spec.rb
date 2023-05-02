# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::AdminDashboardAbility do
  subject(:ability) { described_class.new(parent_ability) }

  let(:parent_ability) { Schematics::Ability.new(user) }
  let(:user) { Core::User.new(role:) }
  let(:role) { Core::Role.new(permissions:) }
  let(:admin_role) { Core::Role.create!(name: 'Admin') }
  let(:permissions) { [] }

  before { admin_role }

  it { is_expected.not_to be_able_to(:read, :admin_dashboard) }

  context 'when one of the requested ability is present' do
    let(:permissions) { [Core::Permission.new(action: 'index', model: 'Permission')] }

    it { is_expected.to be_able_to(:read, :admin_dashboard) }
  end
end
