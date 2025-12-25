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

RSpec.describe Schematics::TriggerWebhookJob do
  let(:event) { Permission.create!(model: 'User', action: 'create') }
  let(:webhook_request) { WebhookRequest.create!(event:, webhook_endpoint:) }
  let(:webhook_endpoint) do
    WebhookEndpoint.create!(
      url: 'https://www.nowhere.com',
      events: [event]
    )
  end

  it { is_expected.to be_a(Schematics::Quietable) }

  describe '#perform_later' do
    it 'queues the job' do
      expect { described_class.perform_later(webhook_request) }
        .to have_enqueued_job(described_class)
        .exactly(:once)
        .with(webhook_request)
        .on_queue('low')
        .at(:no_wait)
    end
  end

  describe '#perform_now' do
    subject(:perform_now) { described_class.perform_now(webhook_request) }

    context 'when the request is successful' do
      before { stub_request(:post, webhook_endpoint.url).to_return(body: '{}', status: 200) }

      it 'updates the state from pending to broadcasted' do
        expect { perform_now }
          .to change(webhook_request, :state)
          .from(WebhookRequest::STATE_STATE_PENDING.to_s)
          .to(WebhookRequest::STATE_STATE_BROADCASTED.to_s)
      end

      it 'updates the response code' do
        expect { perform_now }
          .to change(webhook_request, :response_code)
          .from(nil)
          .to(200)
      end

      it 'updates the response body' do
        expect { perform_now }
          .to change(webhook_request, :response_body)
          .from(nil)
          .to({})
      end
    end

    context 'when the request is successful but the body is not a valid JSON' do
      before { stub_request(:post, webhook_endpoint.url).to_return(body: 'OK', status: 200) }

      it 'updates the response body' do
        expect { perform_now }
          .to change(webhook_request, :response_body)
          .from(nil)
          .to('OK')
      end
    end

    context 'when there is a timeout error' do
      before do
        stub_request(:post, webhook_endpoint.url).to_raise(Timeout::Error.new('Timeout'))
      end

      it 'updates the state from pending to error' do
        expect { perform_now }
          .to change(webhook_request, :state)
          .from(WebhookRequest::STATE_STATE_PENDING.to_s)
          .to(WebhookRequest::STATE_STATE_ERROR.to_s)
      end

      it 'updates the response body' do
        expect { perform_now }
          .to change(webhook_request, :response_body)
          .from(nil)
          .to('error' => 'Timeout')
      end
    end
  end
end
