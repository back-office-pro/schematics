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

      def drafts = ::Draft.none

      def user_groups = []

      def preferences = {}

      def role = ::Role.new(permissions:)

      def confirmed? = true
    end
  end
end
