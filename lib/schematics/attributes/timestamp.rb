# frozen_string_literal: true

module Schematics
  module Attributes
    class Timestamp < Attribute
      def database_type = 'datetime'

      def default = ::Time.current.to_fs(:db)

      def icon = :clock

      def open_api_type = ::DateTime
    end
  end
end
