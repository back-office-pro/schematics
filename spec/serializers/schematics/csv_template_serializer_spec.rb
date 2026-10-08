# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CSVTemplateSerializer do
  subject(:serializer) { described_class.new(model_class) }

  let(:model_class) { Permission }

  its(:file) { is_expected.to be_a(Tempfile) }
  its(:filename) { is_expected.to eq('permissions.csv') }
  its(:extension) { is_expected.to eq(:csv) }
  its(:content_type) { is_expected.to eq('text/csv') }
  its(:content) { is_expected.to be_blank }
end
