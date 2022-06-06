# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::UserAbility do
  subject(:ability) { described_class.new(user) }

  let(:role) { Role.new }
  let(:user) { User.new(role:) }
  let(:admin_role) { Role.create!(name: 'Admin') }

  it { is_expected.not_to be_able_to(:read, :admin_dashboard) }
  it { is_expected.not_to be_able_to(:destroy, user) }
  it { is_expected.not_to be_able_to(:archive, user) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:read, :admin_dashboard) }
  end
end
