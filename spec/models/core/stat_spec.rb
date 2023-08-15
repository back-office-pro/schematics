# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Stat do
  include Schematics::Specs::Model

  its(:model_class) { is_expected.to eq(User) }
  its(:to_s) { is_expected.to eq('Count of users') }
  its(:value_formatted) { is_expected.to be_zero }
  its(:icon) { is_expected.to eq(:users) }

  context 'when model_class does not exist' do
    before { record.model = 'NotExistingModel' }

    its(:model_class) { is_expected.to be_nil }
    its(:to_s) { is_expected.to eq('NotExistingModel is not defined') }
    its(:value_formatted) { is_expected.to eq('-') }
    its(:icon) { is_expected.to eq(:triangle_exclamation) }
  end
end
