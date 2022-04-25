# frozen_string_literal: true

module Schematics
  module Guest
    class User
      delegate :time_zone, to: 'Rails.configuration'
      attr_reader :locale

      def initialize(locale:)
        @locale = locale
      end

      def admin?
        false
      end

      def role
        Role.new # rubocop:disable Lint/ConstantResolution
      end

      def preferences
        {}
      end
    end
  end
end
