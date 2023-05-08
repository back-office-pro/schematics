# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Imports::ValidateData do
  include_context 'with import'

  describe '.call' do
    subject(:call) { described_class.call(import:, data:) }

    context 'when data are valid' do
      let(:data) do
        {
          1 => { 'email' => 'john.doe@back-office.pro', 'role' => role },
          2 => { 'email' => 'jane.doe@back-office.pro', 'role' => role }
        }
      end
      let(:expected_data) do
        [
          {
            'email' => 'john.doe@back-office.pro',
            'locale' => 'en',
            'preferences' => {},
            'time_zone' => 'UTC',
            'role_id' => role.id,
            'lock_version' => 0
          },
          {
            'email' => 'jane.doe@back-office.pro',
            'locale' => 'en',
            'preferences' => {},
            'time_zone' => 'UTC',
            'role_id' => role.id,
            'lock_version' => 0
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
          1 => { 'email' => 'john.doe@back-office.pro', 'role' => role },
          2 => { 'email' => '', 'role' => role }
        }
      end
      let(:expected_data) do
        [
          {
            'email' => 'john.doe@back-office.pro',
            'locale' => 'en',
            'preferences' => {},
            'time_zone' => 'UTC',
            'role_id' => role.id,
            'lock_version' => 0
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
