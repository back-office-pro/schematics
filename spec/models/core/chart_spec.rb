# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chart do
  include Schematics::Specs::Model

  its(:border_width) { is_expected.to eq(1) }
  its(:col_size) { is_expected.to eq(3) }
  its(:max_col_size) { is_expected.to eq(6) }
  its(:filename) { is_expected.to eq('count-of-users-by-identifier') }
  its(:icon) { is_expected.to eq(:chart_line) }
  its(:model_class) { is_expected.to eq(User) }
  its(:suffix) { is_expected.to be_nil }
  its(:to_s) { is_expected.to eq('Count of users by identifier') }
  its(:type) { is_expected.to eq(:line_chart) }
  its(:xtitle) { is_expected.to eq('Identifier') }
  its(:ytitle) { is_expected.to eq('Count of users') }
  its(:serialized_json) { is_expected.to be_empty }
  its(:cached_serialized_json) { is_expected.to be_empty }

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
