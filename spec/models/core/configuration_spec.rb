# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Configuration do
  include Schematics::Specs::Model

  describe '.color_palette' do
    subject { described_class.color_palette }

    let(:expected_color_palette) do
      [
        '#2c3e50',
        '#2c4c50',
        '#2c4550',
        '#2c3e50',
        '#2c3750',
        '#2c3050'
      ]
    end

    it { is_expected.to eq(expected_color_palette) }
  end
end
