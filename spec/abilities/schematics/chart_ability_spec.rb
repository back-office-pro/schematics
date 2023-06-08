# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Schematics::ChartAbility do
  subject(:ability) { described_class.new }

  let(:chart) do
    Chart.create!(
      kind: 'line',
      aggregate: 'count',
      model: 'User',
      x_field: 'User#full_name'
    )
  end

  before { chart }

  it { is_expected.not_to be_able_to(:duplicate, chart) }
  it { is_expected.not_to be_able_to(:update, chart) }
  it { is_expected.not_to be_able_to(:destroy, chart) }
  it { is_expected.not_to be_able_to(:archive, chart) }
end
