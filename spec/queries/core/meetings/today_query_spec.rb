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

RSpec.describe Core::Meetings::TodayQuery do
  include_context 'with user'

  let(:first_meeting) do
    Meeting.create!(
      subject: 'First meeting',
      creator: user,
      start_at: Time.current,
      end_at: 1.hour.from_now,
      participants: [user]
    )
  end
  let(:second_meeting) do
    Meeting.create!(
      subject: 'Second meeting',
      creator: user,
      start_at: Time.current.yesterday,
      end_at: Time.current.yesterday + 1.hour,
      participants: [user]
    )
  end
  let(:third_meeting) do
    Meeting.create!(
      subject: 'Third meeting',
      creator: user,
      start_at: Time.current.tomorrow,
      end_at: Time.current.tomorrow + 1.hour,
      participants: [user]
    )
  end

  before { [first_meeting, second_meeting, third_meeting] }

  its(:call) { is_expected.to contain_exactly(first_meeting) }
end
