# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::RoleAbility do
  subject(:ability) { described_class.new }

  let(:permissions) { Permission.create_entities_permissions! }
  let(:admin_role) { Role.create!(name: 'Admin', permissions:) }

  before { admin_role }

  it { is_expected.not_to be_able_to(:duplicate, admin_role) }
  it { is_expected.not_to be_able_to(:update, admin_role) }
  it { is_expected.not_to be_able_to(:destroy, admin_role) }
  it { is_expected.not_to be_able_to(:archive, admin_role) }
end
