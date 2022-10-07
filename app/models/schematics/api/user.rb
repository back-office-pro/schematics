# frozen_string_literal: true

module Schematics
  module Api
    # :reek:Attribute
    class User
      include ::ActiveModel::API
      delegate :time_zone, to: 'Rails.configuration'
      attr_accessor :permissions

      def admin? = false

      def locale = ::Rails
        .configuration
        .i18n
        .default_locale

      def preferences = {}

      def role = Struct
        .new(:permissions)
        .new(permissions)
    end
  end
end
