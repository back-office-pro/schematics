# frozen_string_literal: true

module Schematics
  class Ability < ApplicationAbility
    def initialize(user)
      super
      merge PermissionAbility.new(user)
      merge ActiveStorage::AttachmentAbility.new(user)
      merge VersionAbility.new(user)
      merge UserAbility.new(user)
      merge MessageAbility.new(user)
      merge DraftAbility.new(user)
      merge ApiRequestAbility.new(user)
      merge DocumentationAbility.new(user)
      merge CommentAbility.new(user)
      merge SchemaDatasetAbility.new
      merge ComparisonAbility.new
      merge SearchAbility.new
      merge RoleAbility.new
      merge FeatureFlagAbility.new
      merge LicenceAbility.new
      merge SessionAbility.new(user)
    end
  end
end
