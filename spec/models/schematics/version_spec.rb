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

RSpec.describe Schematics::Version do
  subject(:version) { described_class.new(event:, item:, user:, object:) }

  include_context 'with user'

  let(:event) { 'update' }
  let(:item) { user }
  let(:object) { user.as_json }
  let(:webhook_endpoint) do
    WebhookEndpoint.create!(
      url: 'https://www.nowhere.com',
      events: [Permission.create!(model: item.class, action: event)]
    )
  end

  before { webhook_endpoint }

  its(:model_class) { is_expected.to eq(User) }
  its(:icon) { is_expected.to eq(:pen_to_square) }

  its(:serialized_json) do
    is_expected.to include(:event, :id, :created_at, :item, :user, :object_changes)
  end

  it 'enqueues a trigger webhook job after create' do
    expect { version.save! }
      .to have_enqueued_job(Schematics::TriggerWebhookJob)
      .exactly(:once)
      .with(WebhookRequest)
      .on_queue('low')
      .at(:no_wait)
  end
end
