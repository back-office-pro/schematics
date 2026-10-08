# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::RecordAbility do
  subject(:ability) { described_class.new }

  it { is_expected.to be_able_to(:create, :all) }
  it { is_expected.to be_able_to(:restore, :all) }
end
