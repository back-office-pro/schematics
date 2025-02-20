# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::RoleAbility do
  subject(:ability) { described_class.new }

  include_context 'with admin role'

  it { is_expected.not_to be_able_to(:duplicate, admin_role) }
  it { is_expected.not_to be_able_to(:update, admin_role) }
  it { is_expected.not_to be_able_to(:destroy, admin_role) }
  it { is_expected.not_to be_able_to(:archive, admin_role) }
end
