# frozen_string_literal: true

module Schematics
  module Behaviours
    module Encryptable
      delegate :encrypted?, to: :options

      def available_options = super.push(Options::Encrypted)

      def to_str
        return super unless encrypted?

        super + <<~RUBY
          encrypts :#{name}, deterministic: true
        RUBY
      end
    end
  end
end
