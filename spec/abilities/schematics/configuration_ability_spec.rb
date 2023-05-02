# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::ConfigurationAbility do
  subject(:ability) { described_class.new(user) }

  let(:role) { Core::Role.new }
  let(:user) { Core::User.new(role:) }
  let(:admin_role) { Core::Role.create!(name: 'Admin') }

  it { is_expected.not_to be_able_to(:show, Core::Configuration) }
  it { is_expected.not_to be_able_to(:update, Core::Configuration) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:show, Core::Configuration) }
    it { is_expected.to be_able_to(:update, Core::Configuration) }
  end
end
