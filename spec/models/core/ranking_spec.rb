# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ranking do
  include Schematics::Specs::Model

  it { is_expected.to be_a(Core::Measurable) }

  its(:icon) { is_expected.to eq(:users) }
  its(:model_class) { is_expected.to eq(User) }
  its(:to_s) { is_expected.to eq('Count of users by identifier since one minute') }
  its(:model_title) { is_expected.to eq('by identifier') }
  its(:aggregate_title) { is_expected.to eq('Count of users') }
  its(:values) { is_expected.to be_empty }

  context 'when model_class does not exist' do
    before { record.model = 'NotExistingModel' }

    its(:model_class) { is_expected.to be_nil }
    its(:to_s) { is_expected.to eq('NotExistingModel is not defined') }
    its(:icon) { is_expected.to eq(:triangle_exclamation) }
    its(:model_title) { is_expected.to be_nil }
    its(:aggregate_title) { is_expected.to be_nil }
  end
end
