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
      merge SettingAbility.new(user)
      merge LicenceAbility.new
      merge ComparisonAbility.new
      merge SearchAbility.new
      merge RoleAbility.new
    end
  end
end
