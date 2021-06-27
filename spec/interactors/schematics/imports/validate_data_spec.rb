# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Imports::ValidateData do
  fixtures :imports

  describe '.call' do
    subject(:call) { described_class.call(import: import, model_class: model_class, data: data) }

    let(:import) { imports(:one) }
    let(:model_class) { Role }

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
            'created_at' => Time,
            'updated_at' => Time
          },
          {
            'name' => 'Role2',
            'slug' => 'role2',
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
