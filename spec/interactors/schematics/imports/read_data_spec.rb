# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::Imports::ReadData do
  include_context 'with import'

  describe '.call' do
    subject(:call) { described_class.call(import:, model_class:) }

    let(:model_class) { Role }
    let(:expected_data) do
      {
        1 => { name: 'Role1' },
        2 => { name: 'Role2' }
      }
    end

    it { is_expected.to be_a_success }
    its(:data) { is_expected.to eq(expected_data) }
  end
end
