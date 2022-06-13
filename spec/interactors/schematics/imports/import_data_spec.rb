# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Imports::ImportData do
  include_context 'with import'

  describe '.call' do
    subject(:call) { described_class.call(import:) }

    it { is_expected.to be_a_success }

    it 'inserts two resources' do
      expect { call }.to change(import.model_class, :count).by(2)
    end

    it 'inserts two versions' do
      expect { call }.to change(Schematics::Version, :count).by(2)
    end
  end
end
