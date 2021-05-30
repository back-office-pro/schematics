# frozen_string_literal: true

require 'schematics/attributes/string'
require 'active_support/values/time_zone'

module Schematics
  module Attributes
    class TimeZone < String
      def icon
        :clock
      end

      def input_type
        :select
      end

      def default
        super || values.first
      end

      def validators
        super.merge(inclusion: { in: values }, allow_nil: !required?)
      end

      def input_collection
        values.collect { |tzone| [tzone, format(tzone)] }
      end

      def format(value)
        value && ActiveSupport::TimeZone[value].to_s
      end

      private

      def values
        ActiveSupport::TimeZone.all.map(&:name)
      end
    end
  end
end
