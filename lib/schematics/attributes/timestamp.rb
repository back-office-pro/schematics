# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Timestamp < Attribute
      include Behaviours::Migratable

      def database_type = 'datetime'

      def default = ::Time.current.to_fs(:db)

      def icon = :clock

      def open_api_schema_type = 'datetime'
    end
  end
end
