# frozen_string_literal: true

module Schematics
  module Behaviours
    module Encryptable
      delegate :encrypted?, to: :options

      def to_str
        return super unless encrypted?

        <<~RUBY
          encrypts :#{name}, deterministic: true
        RUBY
      end
    end
  end
end
