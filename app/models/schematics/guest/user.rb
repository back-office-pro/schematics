# frozen_string_literal: true

module Schematics
  module Guest
    class User
      include ::ActiveModel::API
      include ::ActiveModel::Attributes

      attribute :permissions, default: -> { [] }
      attribute :time_zone, default: -> { ::Configuration.instance.time_zone }
      attribute :locale, default: -> { ::Configuration.instance.locale }

      delegate :admin?, to: :role

      def id = nil

      def drafts = ::Draft.none

      def groups = []

      def preferences = {}

      def role = ::Role.new(permissions:)
    end
  end
end
