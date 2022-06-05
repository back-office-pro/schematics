# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::PdfSerializer do
  subject(:serializer) { described_class.new(user) }

  include_context 'with user'

  its(:file) { is_expected.to be_a(Tempfile) }
  its(:filename) { is_expected.to eq('user-doe-john.pdf') }
  its(:content) { is_expected.to start_with('%PDF') }
  its(:extension) { is_expected.to eq(:pdf) }
  its(:content_type) { is_expected.to eq('application/pdf') }
end
