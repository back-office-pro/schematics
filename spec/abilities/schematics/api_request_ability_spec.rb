# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::ApiRequestAbility do
  subject(:ability) { described_class.new(user) }

  let(:role) { Core::Role.new }
  let(:user) { Core::User.new(role:) }
  let(:permissions) { Core::Permission.create_entities_permissions! }
  let(:admin_role) { Core::Role.create!(name: 'Admin', permissions:) }

  it { is_expected.not_to be_able_to(:read, Core::ApiRequest) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:read, Core::ApiRequest) }
  end
end
