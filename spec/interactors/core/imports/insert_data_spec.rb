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
            'email' => 'john.doe@back-office.pro',
            'role_id' => role.id
          },
          {
            'email' => 'jane.doe@back-office.pro',
            'role_id' => role.id
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
            'email' => 'john.doe@back-office.pro',
            'role_id' => role.id
          },
          {
            'email' => 'john.doe@back-office.pro',
            'role_id' => role.id
          }
        ]
      end

      it { is_expected.to be_a_failure }

      its(:errors) do
        is_expected.to eq('Error' => 'Email john.doe@back-office.pro has already been taken')
      end
    end
  end
end
