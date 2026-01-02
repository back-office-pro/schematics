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

RSpec.describe Schematics::Versions::UnreadQuery do
  subject(:query) { described_class }

  include_context 'with user'

  let(:read_notifications_at) { Time.current }
  let(:first_version) do
    Schematics::Version.create!(
      event: 'update',
      item: user,
      user:,
      created_at: Time.current.tomorrow
    )
  end
  let(:second_version) do
    Schematics::Version.create!(
      event: 'update',
      item: user,
      user:,
      created_at: Time.current.yesterday
    )
  end

  before { [first_version, second_version] }

  describe '.call' do
    subject { query.call(read_notifications_at) }

    it { is_expected.to contain_exactly(first_version) }
  end
end
