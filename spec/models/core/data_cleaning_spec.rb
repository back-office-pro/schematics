# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataCleaning do
  include Schematics::Specs::Model

  its(:model_class) { is_expected.to eq(User) }

  describe '.internal' do
    subject { described_class.internal }

    it { is_expected.to all(be_a(described_class)) }
  end
end
