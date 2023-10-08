# frozen_string_literal: true

module Schematics
  class LicenceAbility < ApplicationAbility
    delegate :quota_users_exceeded?,
             :quota_api_keys_exceeded?,
             :state_inactive?,
             to: '::Licence.instance',
             private: true

    def initialize(user)
      super
      cannot %i[create restore], ::User if quota_users_exceeded?
      cannot %i[create restore], ::ApiKey if quota_api_keys_exceeded?
      cannot %i[create update], :all if state_inactive?
      return unless user.admin?

      can %i[cancel enable], ::Licence
    end
  end
end
