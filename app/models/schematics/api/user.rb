# frozen_string_literal: true

module Schematics
  module Api
    # :reek:Attribute
    class User < Guest::User
      attr_accessor :permissions

      def locale = ::Rails
        .configuration
        .i18n
        .default_locale

      def role = Struct
        .new(:permissions)
        .new(permissions)
    end
  end
end
