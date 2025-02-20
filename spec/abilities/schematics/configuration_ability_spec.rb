# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::ConfigurationAbility do
  subject(:ability) { described_class.new(user) }

  include_context 'with admin role'

  let(:role) { Role.new }
  let(:user) { User.new(role:) }

  it { is_expected.not_to be_able_to(:show, Configuration) }
  it { is_expected.not_to be_able_to(:update, Configuration) }

  context 'when user is admin' do
    let(:role) { admin_role }

    it { is_expected.to be_able_to(:show, Configuration) }
    it { is_expected.to be_able_to(:update, Configuration) }
  end
end
