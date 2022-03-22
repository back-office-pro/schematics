# frozen_string_literal: true

module Schematics
  module Attributes
    class Datetime < Date
      def open_api_type
        ::DateTime
      end

      def format(value)
        value && localize(value, format: '%A %d %B %Y %H:%M')
      end

      def default
        return ::Time.current.yesterday.to_s(:db) if options.before
        return ::Time.current.tomorrow.to_s(:db) if options.after
      end
    end
  end
end
