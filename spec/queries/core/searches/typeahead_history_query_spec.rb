# Copyright © 2025 Dev & Software. All rights reserved.
#
# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Core::Searches::TypeaheadHistoryQuery do
  subject(:query) { described_class }

  include_context 'with user'

  let(:model) { 'User' }
  let(:name) { 'email' }
  let(:first_search) { Search.create!(model:, filters: { email: 'foo' }, user:) }
  let(:second_search) { Search.create!(model:, filters: { email: 'bar' }, user:) }

  before { [first_search, second_search] }

  describe '.call' do
    subject { query.call(model, name) }

    it { is_expected.to eq(%w[bar foo]) }
  end
end
