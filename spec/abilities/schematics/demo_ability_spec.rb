# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::DemoAbility do
  subject(:ability) { described_class.new }

  let(:user) { Core::User.new(role:) }
  let(:role) { Core::Role.create!(name: 'Admin') }

  before { allow(Tenant).to receive(:demo?).and_return(true) }

  it { is_expected.not_to be_able_to(:destroy, user) }
  it { is_expected.not_to be_able_to(:archive, user) }
  it { is_expected.not_to be_able_to(:update, user, :password) }
  it { is_expected.not_to be_able_to(:update, user, :password_confirmation) }
  it { is_expected.not_to be_able_to(:update, user, :email) }
end
