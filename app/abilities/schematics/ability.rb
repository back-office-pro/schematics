# frozen_string_literal: true

module Schematics
  class Ability < ApplicationAbility
    def initialize(user, mod)
      super
      merge PermissionAbility.new(user, mod)
      merge ActiveStorage::AttachmentAbility.new(user, mod)
      merge VersionAbility.new(user, mod)
      merge UserAbility.new(user, mod)
      merge MessageAbility.new(user, mod)
      merge DraftAbility.new(user, mod)
      merge ApiRequestAbility.new(user, mod)
      merge DocumentationAbility.new(user, mod)
      merge CommentAbility.new(user, mod)
      merge SchemaDatasetAbility.new(mod)
      merge ComparisonAbility.new(mod)
      merge SearchAbility.new(mod)
      merge RoleAbility.new(mod)
      merge FeatureFlagAbility.new(mod)
      merge LicenceAbility.new(mod)
      merge SessionAbility.new(user, mod)
    end
  end
end
