# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::CsvTemplateSerializer do
  subject(:serializer) { described_class.new(model_class) }

  let(:model_class) { Permission }

  its(:file) { is_expected.to be_a(Tempfile) }

  its(:content) do
    is_expected.to eq <<~CSV
      Roles


    CSV
  end
end
