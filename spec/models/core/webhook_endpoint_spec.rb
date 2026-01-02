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

RSpec.describe WebhookEndpoint do
  include Schematics::Specs::Model
  include Schematics::ResourcesHelper

  context 'when url is malicious and would lead to an infinite loop' do
    before { record.url = resources_url(User, host: 'localhost', port: 3000) }

    it { is_expected.not_to be_valid }
  end

  describe '.broadcast_all' do
    subject(:broadcast_all) { described_class.broadcast_all(event, payload) }

    let(:event) { record.events.first }
    let(:payload) { {} }

    before { record.save! }

    it 'enqueues a trigger webhook job' do
      expect { broadcast_all }
        .to have_enqueued_job(Schematics::TriggerWebhookJob)
        .exactly(:once)
        .with(WebhookRequest)
        .on_queue('low')
        .at(:no_wait)
    end
  end
end
