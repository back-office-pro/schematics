# frozen_string_literal: true

module Schematics
  class Ability < ApplicationAbility
    def initialize(user)
      super
      return unless user # PDF generation case

      merge PermissionAbility.new(user)
      merge ActiveStorage::AttachmentAbility.new(user)
      merge VersionAbility.new(user)
      merge UserAbility.new(user)
      merge MessageAbility.new(user)
      merge LicenceAbility.new(licence)
      merge RoleAbility.new
    end

    def licence
      @licence ||= ::Licence.instance
    end
  end
end
