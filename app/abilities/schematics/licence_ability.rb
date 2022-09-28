# frozen_string_literal: true

module Schematics
  class LicenceAbility < ApplicationAbility
    delegate :quota_users_exceeded?,
             :quota_storage_exceeded?,
             :active?,
             to: 'Schematics::Licence.instance',
             private: true

    def initialize
      super
      cannot :create, ::User if quota_users_exceeded?
      cannot :create, ::ActiveStorage::Attachment if quota_storage_exceeded?
      cannot :manage, :all unless active?
    end
  end
end
