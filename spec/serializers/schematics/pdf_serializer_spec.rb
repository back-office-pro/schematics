# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::PdfSerializer do
  subject(:serializer) { described_class.new(model_class, resource) }

  fixtures :stats

  let(:model_class) { Stat }
  let(:resource) { stats(:one) }

  its(:file) { is_expected.to be_a(Tempfile) }
  its(:filename) { is_expected.to eq('stat-.pdf') }
  its(:content) { is_expected.to start_with('%PDF') }
end
