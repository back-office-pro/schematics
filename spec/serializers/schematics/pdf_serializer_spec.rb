# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::PdfSerializer do
  subject(:serializer) { described_class.new(model_name, resource) }

  fixtures :stats

  let(:model_name) { 'Stat' }
  let(:resource) { stats(:one) }

  describe '#generate_file' do
    subject { serializer.generate_file }

    it { is_expected.to start_with('%PDF') }
  end
end
