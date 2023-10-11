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
          password: 'Azerty1!',
          time_zone: 'UTC',
          user_groups:,
          role:
        },
        2 => {
          email: 'jane.doe@somewhere.com',
          first_name: 'Jane',
          last_name: 'Doe',
          locale: :fr,
          password: 'Azerty1!',
          time_zone: 'Paris',
          user_groups:,
          role:
        }
      }
    end

    it { is_expected.to be_a_success }
    its(:data) { is_expected.to eq(expected_data) }
  end
end
