# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Metric do
  include Schematics::Specs::Model

  it { is_expected.to be_a(Schematics::Measurable) }
  it { is_expected.to be_exceeded }

  its(:model_class) { is_expected.to eq(User) }
  its(:to_s) { is_expected.to eq('Count of users since one minute') }
  its(:value_formatted) { is_expected.to be_zero }
  its(:icon) { is_expected.to eq(:users) }
  its(:value) { is_expected.to be_zero }
  its(:trend) { is_expected.to be_zero }
  its(:trend_progress) { is_expected.to be_nan }

  context 'when model_class does not exist' do
    before { record.model = 'NotExistingModel' }

    its(:model_class) { is_expected.to be_nil }
    its(:to_s) { is_expected.to eq('NotExistingModel is not defined') }
    its(:value_formatted) { is_expected.to eq('-') }
    its(:icon) { is_expected.to eq(:triangle_exclamation) }
  end
end
