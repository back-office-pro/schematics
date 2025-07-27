# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Token < Attribute
      include Behaviours::Migratable
      include Behaviours::Renderable
      include Behaviours::Encryptable

      LENGTH = 32

      def available_options = super.excluding(Options::Encrypted)

      def database_type = 'string'

      def encrypted? = true

      def unique? = true

      def default = SecureRandom.base58(LENGTH)

      def icon = :passport

      def to_str = super + <<~RUBY
        has_secure_token :#{name}, length: #{LENGTH}
      RUBY
    end
  end
end
