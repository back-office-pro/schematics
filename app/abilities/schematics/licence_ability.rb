# frozen_string_literal: true

module Schematics
  class LicenceAbility < ApplicationAbility
    def initialize(licence)
      super
      cannot :create, ::User if licence.quota_users_exceeded?
      cannot :create, ::ActiveStorage::Attachment if licence.quota_storage_exceeded?
      cannot :manage, :all if licence.expired?
    end
  end
end
