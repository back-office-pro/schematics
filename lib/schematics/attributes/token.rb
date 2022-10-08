# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Token < Attribute
      include Behaviours::Renderable

      def default = SecureRandom.base58

      def icon = :key

      def to_str = <<~RUBY
        has_secure_token :#{name}
      RUBY
    end
  end
end
