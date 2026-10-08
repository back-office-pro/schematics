# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::ComparisonAbility do
  subject(:ability) { described_class.new }

  it { is_expected.to be_able_to(:create, Comparison) }
  it { is_expected.to be_able_to(:show, Comparison) }
end
