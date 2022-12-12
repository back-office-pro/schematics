# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Token < Attribute
      include Behaviours::Renderable
      include Behaviours::Encryptable
      LENGTH = 32

      def encrypted? = true

      def default = SecureRandom.base58

      def icon = :key

      def to_str = super + <<~RUBY
        has_secure_token :#{name}, length: #{LENGTH}
      RUBY
    end
  end
end
