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

RSpec.describe Schematics::SearchIndexes::MultisearchQuery do
  subject(:query) { described_class }

  include_context 'with user'
  include_context 'with admin role'

  let(:role) { admin_role }
  let(:other_user) { User.create!(email: 'jane.doe@nowhere.com', role:) }
  let(:ability) { Schematics::Ability.new(user) }

  before { [user, other_user].each(&:create_search_index) }

  describe '.call' do
    subject { query.call(param, ability) }

    context 'when looking for john' do
      let(:param) { 'john' }

      it { is_expected.to contain_exactly([user]) }
    end

    context 'when looking for jane' do
      let(:param) { 'jane' }

      it { is_expected.to contain_exactly([other_user]) }
    end
  end
end
