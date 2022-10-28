# frozen_string_literal: true

module Schematics
  module Guest
    class User
      include ::ActiveModel::API
      include ::ActiveModel::Attributes

      attribute :permissions, default: -> { [] }
      attribute :time_zone, default: -> { Rails.configuration.time_zone }
      attribute :locale, default: -> { Rails.configuration.i18n.default_locale }

      delegate :admin?, to: :role

      def drafts = ::Draft.none

      def preferences = {}

      def role = ::Role.new(permissions:)
    end
  end
end
