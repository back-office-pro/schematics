# frozen_string_literal: true

module Schematics
  class LicenseAbility < ApplicationAbility
    delegate :users_quota_exceeded?,
             :webhooks_quota_exceeded?,
             :api_keys_quota_exceeded?,
             :roles_quota_exceeded?,
             :teams_quota_exceeded?,
             :active?,
             to: '::Configuration.license',
             private: true

    def initialize
      super

      cannot :create, ::Backup unless active?
      cannot %i[create restore], ::User if users_quota_exceeded?
      cannot %i[create restore], ::WebhookEndpoint if webhooks_quota_exceeded?
      cannot %i[create restore], ::APIKey if api_keys_quota_exceeded?
      cannot %i[create restore], ::Role if roles_quota_exceeded?
      cannot %i[create restore], ::Team if teams_quota_exceeded?
    end
  end
end
