# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Imports::InsertData do
  include_context 'with import'

  describe '.call' do
    subject(:call) { described_class.call(import:, data:) }

    context 'when data are valid' do
      let(:data) do
        [
          {
            id: '1pd2jv9zfz9b38m3mhe6pbw5sw',
            email: 'john.doe@somewhere.com',
            first_name: 'John',
            last_name: 'Doe',
            locale: 'en',
            lock_version: 0,
            password_digest: String,
            preferences: {},
            role_id: role.id,
            slug: 'john-doe',
            time_zone: 'UTC'
          },
          {
            id: '6mq63m1z0b8ser84wcg8fqg6as',
            email: 'jane.doe@somewhere.com',
            first_name: 'Jane',
            last_name: 'Doe',
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

      it 'inserts two resources' do
        expect { call }.to change(import.model_class, :count).by(2)
      end

      it 'inserts two versions' do
        expect { call }.to change(Schematics::Version, :count).by(2)
      end
    end

    context 'when data are not valid' do
      let(:data) do
        [
          {
            id: '1pd2jv9zfz9b38m3mhe6pbw5sw',
            email: 'john.doe@somewhere.com',
            first_name: 'John',
            last_name: 'Doe',
            locale: 'en',
            lock_version: 0,
            password_digest: String,
            preferences: {},
            role_id: role.id,
            slug: 'john-doe',
            time_zone: 'UTC'
          },
          {
            id: '6mq63m1z0b8ser84wcg8fqg6as',
            email: 'john.doe@somewhere.com',
            first_name: 'John',
            last_name: 'Doe',
            locale: 'en',
            lock_version: 0,
            password_digest: String,
            preferences: {},
            role_id: role.id,
            slug: 'john-doe',
            time_zone: 'UTC'
          }
        ]
      end

      it { is_expected.to be_a_success }
      its('import.progress') { is_expected.to eq(100) }

      it 'inserts only one resource' do
        expect { call }.to change(import.model_class, :count).by(1)
      end

      it 'inserts only one version' do
        expect { call }.to change(Schematics::Version, :count).by(1)
      end
    end
  end
end
