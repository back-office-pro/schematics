# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CsvTemplateSerializer do
  subject(:serializer) { described_class.new(model_class) }

  let(:model_class) { Permission }

  describe '#generate_file' do
    subject { serializer.generate_file }

    let(:expected_content) do
      <<~CSV
        Roles


      CSV
    end

    it { is_expected.to eq(expected_content) }
  end
end
