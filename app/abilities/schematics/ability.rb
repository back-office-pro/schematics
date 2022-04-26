# frozen_string_literal: true

module Schematics
  class Ability < ApplicationAbility
    def initialize(user)
      super
      merge PermissionAbility.new(user)
      merge ActiveStorage::AttachmentAbility.new(user) # rubocop:disable Lint/ConstantResolution
      merge VersionAbility.new(user)
      merge UserAbility.new(user)
      merge MessageAbility.new(user)
      merge SettingAbility.new(user)
      merge DraftAbility.new(user)
      merge SessionAbility.new(user)
      merge LicenceAbility.new
      merge ComparisonAbility.new
      merge SearchAbility.new
      merge RoleAbility.new
    end
  end
end
