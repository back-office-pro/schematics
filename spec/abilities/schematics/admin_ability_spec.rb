# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::AdminAbility do
  subject(:ability) { described_class.new(parent_ability) }

  let(:parent_ability) { Schematics::Ability.new(user) }
  let(:user) { User.new(role:) }
  let(:role) { Role.new(permissions:) }
  let(:permissions) { [] }

  it { is_expected.not_to be_able_to(:index, :admin) }

  context 'when one of the requested ability is present' do
    let(:permissions) { [Permission.new(action: 'index', model: 'Permission')] }

    it { is_expected.to be_able_to(:index, :admin) }
  end
end
