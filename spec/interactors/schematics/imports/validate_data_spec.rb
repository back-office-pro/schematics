# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Imports::ValidateData do
  include_context 'with import'

  describe '.call' do
    subject(:call) { described_class.call(import:, model_class:, data:) }

    context 'when data are valid' do
      let(:data) do
        {
          1 => { 'name' => 'Role1' },
          2 => { 'name' => 'Role2' }
        }
      end
      let(:expected_data) do
        [
          {
            'name' => 'Role1',
            'slug' => 'role1',
            'lock_version' => 0,
            'created_at' => Time,
            'updated_at' => Time
          },
          {
            'name' => 'Role2',
            'slug' => 'role2',
            'lock_version' => 0,
            'created_at' => Time,
            'updated_at' => Time
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
          1 => { 'name' => 'Role1' },
          2 => { 'name' => '' }
        }
      end
      let(:expected_data) do
        [
          {
            'name' => 'Role1',
            'slug' => 'role1',
            'lock_version' => 0,
            'created_at' => Time,
            'updated_at' => Time
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
