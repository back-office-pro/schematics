# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::PermissionAbility do
  subject(:ability) { described_class.new(user) }

  include_context 'with user'

  before { allow(Configuration).to receive(:license_active?).and_return(true) }

  it { is_expected.to be_able_to(:index, Import) }
end
