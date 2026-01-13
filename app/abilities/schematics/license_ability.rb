# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  class LicenseAbility < ApplicationAbility
    delegate :users_quota_exceeded?,
             :webhooks_quota_exceeded?,
             :api_keys_quota_exceeded?,
             :roles_quota_exceeded?,
             :teams_quota_exceeded?,
             to: '::Configuration.license',
             private: true

    def initialize
      super

      cannot %i[create restore], ::User if users_quota_exceeded?
      cannot %i[create restore], ::WebhookEndpoint if webhooks_quota_exceeded?
      cannot %i[create restore], ::APIKey if api_keys_quota_exceeded?
      cannot %i[create restore], ::Role if roles_quota_exceeded?
      cannot %i[create restore], ::Team if teams_quota_exceeded?
    end
  end
end
