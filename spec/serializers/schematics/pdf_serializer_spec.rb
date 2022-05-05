# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::PdfSerializer do
  subject(:serializer) { described_class.new(model_name, resource) }

  fixtures :stats

  let(:model_name) { 'Stat' }
  let(:resource) { stats(:one) }

  its(:file) { is_expected.to be_a(Tempfile) }
  its(:content) { is_expected.to start_with('%PDF') }
end
