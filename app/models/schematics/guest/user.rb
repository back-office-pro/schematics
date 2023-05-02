# frozen_string_literal: true

module Schematics
  module Guest
    class User
      include ::ActiveModel::API
      include ::ActiveModel::Attributes

      attribute :permissions, default: -> { [] }
      attribute :time_zone, default: -> { Core::Configuration.time_zone }
      attribute :locale, default: -> { Core::Configuration.locale }

      delegate :admin?, to: :role

      def id = nil

      def drafts = Core::Draft.none

      def user_groups = []

      def preferences = {}

      def role = Core::Role.new(permissions:)
    end
  end
end
