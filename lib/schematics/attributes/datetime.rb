# frozen_string_literal: true

module Schematics
  module Attributes
    class Datetime < Date
      def open_api_type = ::DateTime

      def format(value)
        value && localize(value, format: :long)
      end

      def default
        return ::Time.current.yesterday.to_fs(:db) if options.less_than
        return ::Time.current.tomorrow.to_fs(:db) if options.greater_than
      end
    end
  end
end
