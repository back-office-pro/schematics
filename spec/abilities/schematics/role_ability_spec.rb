# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::RoleAbility do
  subject(:ability) { described_class.new }

  let(:admin_role) { create(:role, name: 'Admin') }

  before { admin_role }

  it { is_expected.not_to be_able_to(:update, admin_role) }
  it { is_expected.not_to be_able_to(:destroy, admin_role) }
  it { is_expected.not_to be_able_to(:archive, admin_role) }
end
