# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::DraftAbility do
  subject(:ability) { described_class.new(user) }

  let(:user) { User.new }
  let(:draft) { Draft.new(user:) }

  it { is_expected.to be_able_to(:update, draft) }
end
