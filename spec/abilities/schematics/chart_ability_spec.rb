# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::ChartAbility do
  subject(:ability) { described_class.new(user) }

  let(:user) { User.new(role:) }
  let(:role) { Role.new }

  it { is_expected.not_to be_able_to(:show, Chart.api) }
  it { is_expected.not_to be_able_to(:duplicate, Chart.api) }
  it { is_expected.not_to be_able_to(:update, Chart.api) }
  it { is_expected.not_to be_able_to(:destroy, Chart.api) }
  it { is_expected.not_to be_able_to(:archive, Chart.api) }
end
