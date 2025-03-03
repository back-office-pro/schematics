# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Demo::DataCleaning do
  include Schematics::Specs::Model
  include ActiveSupport::Testing::TimeHelpers

  around do |example|
    freeze_time { example.run }
  end

  its(:model_class) { is_expected.to eq(Team) }
  its(:query_method) { is_expected.to eq(:destroy!) }
  its(:query_field) { is_expected.to eq(:deadline) }
  its(:query_range) { is_expected.to eq(..1.hour.ago) }

  describe '.internal' do
    subject { described_class.internal }

    it { is_expected.to all(be_a(described_class)) }
  end
end
