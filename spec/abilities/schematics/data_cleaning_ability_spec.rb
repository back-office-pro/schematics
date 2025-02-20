# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::DataCleaningAbility do
  subject(:ability) { described_class.new }

  it { is_expected.not_to be_able_to(:duplicate, DataCleaning) }
  it { is_expected.not_to be_able_to(:update, DataCleaning.internal) }
  it { is_expected.not_to be_able_to(:destroy, DataCleaning.internal) }
end
