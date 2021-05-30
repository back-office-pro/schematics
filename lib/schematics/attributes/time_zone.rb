# frozen_string_literal: true

require 'schematics/attributes/string'
require 'schematics/behaviours/enumerable'
require 'active_support/values/time_zone'

module Schematics
  module Attributes
    class TimeZone < String
      include Behaviours::Enumerable

      def icon
        :clock
      end

      def format(value)
        value && ActiveSupport::TimeZone[value].to_s
      end

      def values
        ActiveSupport::TimeZone.all.map(&:name)
      end
    end
  end
end
