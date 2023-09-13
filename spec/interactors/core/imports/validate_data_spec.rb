# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Imports::ValidateData do
  include_context 'with import'

  describe '.call' do
    subject(:call) { described_class.call(import:, data:) }

    context 'when data are valid' do
      let(:data) do
        {
          1 => {
            email: 'john.doe@somewhere.com',
            first_name: 'Doe',
            last_name: 'John',
            locale: :en,
            password: 'Azerty1!',
            time_zone: 'UTC',
            user_groups:,
            role:
          },
          2 => {
            email: 'jane.doe@somewhere.com',
            first_name: 'Doe',
            last_name: 'Jane',
            locale: :fr,
            password: 'Azerty1!',
            time_zone: 'Paris',
            user_groups:,
            role:
          }
        }
      end
      let(:expected_data) do
        [
          {
            email: 'john.doe@somewhere.com',
            first_name: 'Doe',
            last_name: 'John',
            locale: 'en',
            lock_version: 0,
            password_digest: String,
            preferences: {},
            role_id: role.id,
            slug: 'john-doe',
            time_zone: 'UTC'
          },
          {
            email: 'jane.doe@somewhere.com',
            first_name: 'Doe',
            last_name: 'Jane',
            locale: 'fr',
            lock_version: 0,
            password_digest: String,
            preferences: {},
            role_id: role.id,
            slug: 'jane-doe',
            time_zone: 'Paris'
          }
        ]
      end

      it { is_expected.to be_a_success }
      its('import.progress') { is_expected.to eq(100) }
      its(:data) { is_expected.to match(expected_data) }
    end

    context 'when data are not valid' do
      let(:data) do
        {
          1 => {
            email: 'john.doe@somewhere.com',
            first_name: 'Doe',
            last_name: 'John',
            locale: :en,
            password: 'Azerty1!',
            time_zone: 'UTC',
            user_groups:,
            role:
          },
          2 => {
            email: '',
            first_name: 'Doe',
            last_name: 'Jane',
            locale: :fr,
            password: 'Azerty1!',
            time_zone: 'Paris',
            user_groups:,
            role:
          }
        }
      end
      let(:expected_data) do
        [
          {
            email: 'john.doe@somewhere.com',
            first_name: 'Doe',
            last_name: 'John',
            locale: 'en',
            lock_version: 0,
            password_digest: String,
            preferences: {},
            role_id: role.id,
            slug: 'john-doe',
            time_zone: 'UTC'
          },
          ActiveRecord::RecordInvalid
        ]
      end

      it { is_expected.to be_a_failure }
      its('import.progress') { is_expected.to eq(100) }
      its(:data) { is_expected.to match(expected_data) }

      its(:errors) do
        is_expected.to match(I18n.t('line', line: 2) => ActiveRecord::RecordInvalid)
      end
    end
  end
end
