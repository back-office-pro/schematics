# Copyright © 2025 Dev & Software. All rights reserved.
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
      let(:expected_data) do
        [
          {
            id: String,
            email: 'john.doe@somewhere.com',
            first_name: 'John',
            last_name: 'DOE',
            locale: 'en',
            lock_version: 0,
            password_digest: String,
            preferences: {},
            role_id: role.id,
            slug: 'doe-john-2',
            time_zone: 'UTC'
          },
          {
            id: String,
            email: 'jane.doe@somewhere.com',
            first_name: 'Jane',
            last_name: 'DOE',
            locale: 'fr',
            lock_version: 0,
            password_digest: String,
            preferences: {},
            role_id: role.id,
            slug: 'doe-jane',
            time_zone: 'Paris'
          }
        ]
      end

      it { is_expected.to be_a_success }
      its('import.progress') { is_expected.to eq(90) }
      its(:data) { is_expected.to match(expected_data) }
    end

    context 'when data are not valid' do
      let(:data) do
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
            email: '',
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
      let(:expected_data) do
        [
          {
            id: String,
            email: 'john.doe@somewhere.com',
            first_name: 'John',
            last_name: 'DOE',
            locale: 'en',
            lock_version: 0,
            password_digest: String,
            preferences: {},
            role_id: role.id,
            slug: 'doe-john-2',
            time_zone: 'UTC'
          },
          ActiveRecord::RecordInvalid
        ]
      end

      it { is_expected.to be_a_failure }
      its('import.progress') { is_expected.to eq(90) }
      its(:data) { is_expected.to match(expected_data) }

      its(:errors) do
        is_expected.to match(2 => ActiveRecord::RecordInvalid)
      end
    end
  end
end
