# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class OneTimePassword < Attribute
      include Behaviours::Migratable
      include Behaviours::Encryptable

      def available_options = super.excluding(Options::Encrypted)

      def database_type = 'string'

      def encrypted? = true

      def default = nil

      def icon = :mobile_screen

      def to_str = super + <<~RUBY
        has_one_time_password column_name: :#{name},
                              after_column_name: :otp_last_at,
                              one_time_backup_codes: true
      RUBY
    end
  end
end
