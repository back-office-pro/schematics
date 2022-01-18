# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Imports::ReadData do
  fixtures :users

  describe '.call' do
    subject(:call) { described_class.call(import:, model_class:) }

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
    let(:expected_data) do
      {
        1 => { 'name' => 'Role1' },
        2 => { 'name' => 'Role2' }
      }
    end

    it { is_expected.to be_a_success }
    its(:data) { is_expected.to eq(expected_data) }
  end
end
