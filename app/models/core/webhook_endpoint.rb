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

class ::WebhookEndpoint < Schematics::ApplicationRecord
  validates :url, exclusion: { in: :denied_urls }

  scope :subscribed, ::Core::WebhookEndpoints::SubscribedQuery

  class << self
    def broadcast_all(event, payload)
      ActiveJob.perform_all_later(
        subscribed(event)
          .map { WebhookRequest.create!(webhook_endpoint: _1, event:, payload:) }
          .map(&Schematics::TriggerWebhookJob.method(:new))
      )
    end
  end

  private

  def denied_urls = events
    .map(&:webhook_url)
    .uniq
end
