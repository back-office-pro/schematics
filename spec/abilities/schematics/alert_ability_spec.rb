# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::AlertAbility do
  subject(:ability) { described_class.new }

  it { is_expected.to be_able_to(:alert, :all) }
  it { is_expected.not_to be_able_to(:alert, Alert) }
end
