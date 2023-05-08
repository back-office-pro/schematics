# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Imports::ReadData do
  include_context 'with import'

  describe '.call' do
    subject(:call) { described_class.call(import:) }

    let(:expected_data) do
      {
        1 => { email: 'john.doe@back-office.pro', role: },
        2 => { email: 'jane.doe@back-office.pro', role: }
      }
    end

    it { is_expected.to be_a_success }
    its(:data) { is_expected.to eq(expected_data) }
  end
end
