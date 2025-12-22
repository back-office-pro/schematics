# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::LicenseAbility do
  subject(:ability) { described_class.new }

  context 'when subscription is inactive' do
    before { Subscription.instance.state_inactive! }

    it { is_expected.not_to be_able_to(:create, :all) }
    it { is_expected.not_to be_able_to(:restore, :all) }
    it { is_expected.not_to be_able_to(:update, :all) }
  end
end
