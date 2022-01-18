# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Imports::InsertData do
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
        [
          {
            'name' => 'Role1',
            'slug' => 'role1',
            'created_at' => Time.current,
            'updated_at' => Time.current
          },
          {
            'name' => 'Role2',
            'slug' => 'role2',
            'created_at' => Time.current,
            'updated_at' => Time.current
          }
        ]
      end

      it { is_expected.to be_a_success }

      it 'inserts two roles' do
        expect { call }.to change(model_class, :count).by(2)
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
            'slug' => 'role1',
            'created_at' => Time.current,
            'updated_at' => Time.current
          },
          {
            'name' => 'Role1',
            'slug' => 'role1',
            'created_at' => Time.current,
            'updated_at' => Time.current
          }
        ]
      end

      it { is_expected.to be_a_failure }
      its(:errors) { is_expected.to eq({ 'Error' => 'name Role1 already exists' }) }
    end
  end
end
