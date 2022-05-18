# frozen_string_literal: true

require 'active_support/values/time_zone'

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class TimeZone < String
      include Behaviours::Enumerable

      def icon = :clock

      def format(value)
        value && ActiveSupport::TimeZone[value].to_s
      end

      def values = ActiveSupport::TimeZone
        .all
        .map(&:name)
    end
  end
end
