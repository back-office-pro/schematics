# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Imports::ValidateData do
  fixtures :users

  describe '.call' do
    subject(:call) { described_class.call(import:, model_class:, data:) }

    let(:import) { Import.create(file:, author:) } # TODO: refactor to fixture
    let(:author) { users(:one) }
    let(:model_class) { Role }
    let(:file) do
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(file_fixture('roles.csv'), 'rb'),
        filename: 'roles.csv',
        content_type: 'text/csv'
      ).signed_id
    end

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

      around do |example|
        I18n.with_locale(:en, &example)
      end

      it { is_expected.to be_a_failure }
      its('import.progress') { is_expected.to eq(100) }
      its(:data) { is_expected.to match(expected_data) }
      its(:errors) { is_expected.to match({ 'Line 2' => ActiveRecord::RecordInvalid }) }
    end
  end
end
