# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schematics::PDFSerializer do
  subject(:serializer) { described_class.new(user) }

  include_context 'with user'

  let(:template) { PDFTemplate.create!(model: 'User', content: 'Custom template') }

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
