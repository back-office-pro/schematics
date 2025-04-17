# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class ConfigurationAbility < ApplicationAbility
    def initialize(user)
      super
      return unless user.admin?

      can %i[show update], ::Configuration
      return if Rails.env.on_premise?

      cannot :update, ::Configuration, %i[
        gcloud_public_api_key
        gcloud_private_api_key
        aws_access_key_id
        aws_secret_access_key
        aws_region
        azure_storage_account_name
        azure_storage_access_key
        gcs_private_key_id
        gcs_private_key
      ]
    end
  end
end
