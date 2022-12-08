# frozen_string_literal: true

module Schematics
  module Guest
    class User
      include ::ActiveModel::API
      include ::ActiveModel::Attributes

      attribute :permissions, default: -> { [] }
      attribute :time_zone, default: -> { Dummy::Configuration.instance.time_zone }
      attribute :locale, default: -> { Dummy::Configuration.instance.locale }

      delegate :admin?, to: :role

      def drafts = Dummy::Draft.none

      def preferences = {}

      def role = Dummy::Role.new(permissions:)
    end
  end
end
