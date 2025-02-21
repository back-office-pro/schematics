# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::PDFSerializer do
  subject(:serializer) { described_class.new(user, url_options) }

  include_context 'with user'

  let(:template) { PDFTemplate.create!(model: 'User', content: 'Custom template') }
  let(:url_options) { { host: 'localhost', port: 3000 } }

  its(:file) { is_expected.to be_a(Tempfile) }
  its(:filename) { is_expected.to eq('user-doe-john.pdf') }
  its(:content) { is_expected.to start_with('%PDF') }
  its(:extension) { is_expected.to eq(:pdf) }
  its(:content_type) { is_expected.to eq('application/pdf') }

  context 'when there is a custom template' do
    before { template }

    its(:file) { is_expected.to be_a(Tempfile) }
    its(:content) { is_expected.to start_with('%PDF') }
  end
end
