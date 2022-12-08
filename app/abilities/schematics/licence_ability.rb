# frozen_string_literal: true

module Schematics
  class LicenceAbility < ApplicationAbility
    delegate :quota_users_exceeded?,
             :quota_storage_exceeded?,
             :active?,
             to: :licence,
             private: true

    def initialize(mod)
      super
      @mod = mod
      cannot :create, mod::User if quota_users_exceeded?
      cannot :create, ::ActiveStorage::Attachment if quota_storage_exceeded?
      cannot %i[create update], :all unless active?
    end

    private

    def licence
      @licence ||= @mod::Licence.instance
    end
  end
end
