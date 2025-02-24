# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class Ability < ApplicationAbility
    def initialize(user, mod, schema = Schema.new)
      super
      merge PermissionAbility.new(user)
      merge ActiveStorage::AttachmentAbility.new(user)
      merge ActiveStorage::BlobAbility.new
      merge VersionAbility.new(user, mod)
      merge UserAbility.new(user, mod)
      merge CommentAbility.new(user, mod)
      merge MessageAbility.new(user, mod)
      merge DraftAbility.new(user, mod)
      merge ConfigurationAbility.new(user, mod)
      merge APIRequestAbility.new(user, mod)
      merge WebhookRequestAbility.new(user, mod)
      merge ChartAbility.new(user, mod)
      merge DataCleaningAbility.new(mod)
      merge PDFTemplateAbility.new(mod)
      merge EmailTemplateAbility.new(mod)
      merge EmailingAbility.new(mod)
      merge MigrationAbility.new(mod)
      merge ComparisonAbility.new(mod)
      merge SearchAbility.new(mod)
      merge RoleAbility.new(mod)
      merge AdminAbility.new(self, mod)
      merge FeatureFlagAbility.new(mod)
      merge SubscriptionAbility.new(user, mod)
      merge SessionAbility.new(user, mod)
      merge TeamAbility.new(user, mod, schema)
    end
  end
end
