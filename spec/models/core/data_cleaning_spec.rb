# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataCleaning do
  include Schematics::Specs::Model

  its(:model_class) { is_expected.to eq(User) }
  its(:query_method) { is_expected.to eq(:destroy_all) }
  its(:query_filters) { is_expected.to eq(created_at: ..1.week.ago) }

  describe '.internal' do
    subject { described_class.internal }

    it { is_expected.to all(be_a(described_class)) }
  end
end
