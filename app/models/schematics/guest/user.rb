# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
module Schematics
  module Guest
    class User
      include ::ActiveModel::API
      include ::ActiveModel::Attributes

      attribute :permissions, default: -> { [] }
      attribute :time_zone, default: -> { ::Configuration.time_zone_with_fallback }
      attribute :locale, default: -> { ::Configuration.locale }

      delegate :admin?, to: :role

      def id = nil

      def teams = ::Team.none

      def preferences = {}

      def preferences_theme = nil

      def role = ::Role.new(permissions:)

      def otp_enabled? = false

      def update(*) = false

      def authenticate(*) = false

      def log_search!(*) = false

      def find_or_create_draft!(*) = nil

      def provisioning_uri(*) = nil
    end
  end
end
