# frozen_string_literal: true

module Schematics
  class LicenceAbility < ApplicationAbility
    delegate :quota_users_exceeded?,
             :quota_storage_exceeded?,
             :state_inactive?,
             to: 'Core::Licence.instance',
             private: true

    def initialize(user)
      super
      cannot :create, Core::User if quota_users_exceeded?
      cannot :create, ::ActiveStorage::Attachment if quota_storage_exceeded?
      cannot %i[create update], :all if state_inactive?
      return unless user.admin?

      can %i[cancel enable], Core::Licence
    end
  end
end
