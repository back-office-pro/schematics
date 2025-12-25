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

RSpec.describe Message do
  include Schematics::Specs::Model

  include_context 'with user'

  its(:rich_text_mentions) { is_expected.to be_empty }

  it 'does not send notifications after save' do
    expect { record.save! }
      .not_to have_enqueued_job(Schematics::NotifyJob)
      .exactly(:once)
      .with(record, 'mention', user)
      .on_queue('low')
      .at(:no_wait)
  end

  describe '#read?' do
    subject { record.read?(record.author) }

    it { is_expected.to be_falsy }
  end

  describe '#new_reply' do
    subject { record.new_reply }

    it { is_expected.to be_a(described_class) }
    its(:subject) { is_expected.to start_with('RE:') }
  end
end
