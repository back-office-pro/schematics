# frozen_string_literal: true

module Schematics
  class Ability < ApplicationAbility
    def initialize(user)
      super
      merge PermissionAbility.new(user)
      merge ActiveStorage::AttachmentAbility.new(user)
      merge ActiveStorage::BlobAbility.new
      merge VersionAbility.new(user)
      merge UserAbility.new(user)
      merge MessageAbility.new(user)
      merge DraftAbility.new(user)
      merge ConfigurationAbility.new(user)
      merge ApiRequestAbility.new(user)
      merge CommentAbility.new(user)
      merge SchemaDatasetAbility.new
      merge ComparisonAbility.new
      merge BlogAbility.new
      merge SearchAbility.new
      merge ChartAbility.new
      merge RoleAbility.new
      merge AdminDashboardAbility.new(self)
      merge FeatureFlagAbility.new
      merge DemoAbility.new
      merge LicenceAbility.new(user)
      merge SessionAbility.new(user)
      merge UserGroupAbility.new(user)
    end
  end
end
