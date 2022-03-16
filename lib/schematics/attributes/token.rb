# frozen_string_literal: true

require 'active_support/core_ext/securerandom'

module Schematics
  module Attributes
    class Token < Attribute
      def unique?
        true
      end

      def default
        SecureRandom.base58
      end

      def to_str
        <<~RUBY
          has_secure_token :#{name}
        RUBY
      end
    end
  end
end
