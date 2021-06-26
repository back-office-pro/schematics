# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Imports::ImportData do
  fixtures :users

  describe '.call' do
    subject(:call) { described_class.call(import: import, model_class: model_class) }

    let(:import) { Import.create(file: file.signed_id, author: author) }
    let(:author) { users(:one) }
    let(:model_class) { Role }
    let(:file) do
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(file_fixture('roles.csv'), 'rb'),
        filename: 'roles.csv',
        content_type: 'text/csv'
      )
    end

    it { is_expected.to be_a_success }

    it 'inserts two roles' do
      expect { call }.to change(model_class, :count).by(2)
    end

    it 'inserts two versions' do
      expect { call }.to change(Schematics::Version, :count).by(2)
    end
  end
end
