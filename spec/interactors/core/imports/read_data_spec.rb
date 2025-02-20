# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Imports::ReadData do
  include_context 'with import'

  describe '.call' do
    subject(:call) { described_class.call(import:) }

    let(:expected_data) do
      {
        1 => {
          email: 'john.doe@somewhere.com',
          first_name: 'John',
          last_name: 'Doe',
          locale: :en,
          password: Schematics::Attributes::Digest::DEFAULT,
          time_zone: 'UTC',
          teams:,
          role:
        },
        2 => {
          email: 'jane.doe@somewhere.com',
          first_name: 'Jane',
          last_name: 'Doe',
          locale: :fr,
          password: Schematics::Attributes::Digest::DEFAULT,
          time_zone: 'Paris',
          teams:,
          role:
        }
      }
    end

    it { is_expected.to be_a_success }
    its('import.progress') { is_expected.to eq(10) }
    its(:data) { is_expected.to eq(expected_data) }
  end
end
