# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::DemoAbility do
  subject(:ability) { described_class.new }

  include_context 'with admin role'

  let(:user) { User.new(role:) }
  let(:role) { admin_role }

  it { is_expected.not_to be_able_to(:destroy, user) }
  it { is_expected.not_to be_able_to(:archive, user) }
  it { is_expected.not_to be_able_to(:update, user, :password) }
  it { is_expected.not_to be_able_to(:update, user, :password_confirmation) }
  it { is_expected.not_to be_able_to(:update, user, :email) }
end
