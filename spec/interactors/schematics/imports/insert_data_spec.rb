# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Imports::InsertData do
  include_context 'with import'

  describe '.call' do
    subject(:call) { described_class.call(import:, data:) }

    context 'when data are valid' do
      let(:data) do
        [
          {
            'name' => 'Role1',
            'slug' => 'role1'
          },
          {
            'name' => 'Role2',
            'slug' => 'role2'
          }
        ]
      end

      it { is_expected.to be_a_success }

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
            'name' => 'Role1',
            'slug' => 'role1'
          },
          {
            'name' => 'Role1',
            'slug' => 'role1'
          }
        ]
      end

      it { is_expected.to be_a_failure }
      its(:errors) { is_expected.to eq('Error' => 'name Role1 already exists') }
    end
  end
end
