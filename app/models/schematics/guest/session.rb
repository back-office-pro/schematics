# frozen_string_literal: true

module Schematics
  module Guest
    # :reek:MissingSafeMethod
    class Session
      def initialize(request:)
        @request = request
      end

      def user
        User.new(locale:) # rubocop:disable Lint/ConstantResolution
      end

      def locale
        @request
          .env['HTTP_ACCEPT_LANGUAGE']
          &.scan(/^[a-z]{2}/)
          &.to_a
          &.first
          &.to_sym
      end

      def authorized?
        false
      end

      def update!(*); end
    end
  end
end
