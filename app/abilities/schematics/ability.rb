# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class Ability < ApplicationAbility
    def initialize(user, schema = Schema.new)
      super
      merge PermissionAbility.new(user)
      merge LicenseAbility.new
      merge ActiveStorage::AttachmentAbility.new(user)
      merge ActiveStorage::BlobAbility.new
      merge VersionAbility.new(user)
      merge UserAbility.new(user)
      merge CommentAbility.new(user)
      merge MessageAbility.new(user)
      merge DraftAbility.new(user)
      merge ConfigurationAbility.new(user)
      merge APIRequestAbility.new(user)
      merge WebhookRequestAbility.new(user)
      merge ChartAbility.new(user)
      merge DataCleaningAbility.new
      merge PDFTemplateAbility.new
      merge EmailTemplateAbility.new
      merge EmailingAbility.new
      merge MigrationAbility.new
      merge ComparisonAbility.new
      merge SearchAbility.new
      merge RoleAbility.new
      merge AdminAbility.new(self)
      merge FeatureFlagAbility.new
      merge SessionAbility.new(user)
      merge TeamAbility.new(user, schema)
    end
  end
end
