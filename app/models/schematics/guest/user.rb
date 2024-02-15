# frozen_string_literal: true

module Schematics
  module Guest
    class User
      include ::ActiveModel::API
      include ::ActiveModel::Attributes

      attribute :permissions, default: -> { [] }
      attribute :time_zone, default: -> { ::Configuration.time_zone }
      attribute :locale, default: -> { ::Configuration.locale }

      delegate :admin?, to: :role

      def id = nil

      def user_groups = ::UserGroup.none

      def preferences = {}

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
