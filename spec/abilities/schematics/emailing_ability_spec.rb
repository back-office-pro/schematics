# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::EmailingAbility do
  subject(:ability) { described_class.new }

  it { is_expected.to be_able_to(:email, :all) }
  it { is_expected.not_to be_able_to(:email, Emailing) }
end
