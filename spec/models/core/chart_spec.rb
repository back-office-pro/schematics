# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chart do
  include Schematics::Specs::Model

  it { is_expected.to be_a(Schematics::Measurable) }

  its(:icon) { is_expected.to eq(:chart_line) }
  its(:model_class) { is_expected.to eq(User) }
  its(:serialized_json) { is_expected.to be_empty }
  its(:cached_serialized_json) { is_expected.to be_empty }
  its(:to_s) { is_expected.to eq('Count of users per identifier since one minute') }
  its(:xtitle) { is_expected.to eq('Identifier') }
  its(:ytitle) { is_expected.to eq('Count of users') }

  context 'when model_class does not exist' do
    before { record.model = 'NotExistingModel' }

    its(:icon) { is_expected.to eq(:triangle_exclamation) }
    its(:model_class) { is_expected.to be_nil }
    its(:serialized_json) { is_expected.to be_nil }
    its(:cached_serialized_json) { is_expected.to be_nil }
    its(:to_s) { is_expected.to eq('NotExistingModel is not defined') }
    its(:xtitle) { is_expected.to be_nil }
    its(:ytitle) { is_expected.to be_nil }
  end

  describe '.api' do
    subject { described_class.api }

    it { is_expected.to be_a(described_class) }
    its(:model) { is_expected.to eq('APIRequest') }
  end
end
