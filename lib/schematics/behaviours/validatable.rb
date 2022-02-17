# frozen_string_literal: true

require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/module/delegation'

module Schematics
  module Behaviours
    module Validatable
      delegate :unique?, :required?, to: :options

      def allow_blank
        !required?
      end

      def case_sensitive?
        true
      end

      def validate
        return if validators.empty?

        <<~RUBY
          validates :#{name}, #{validators}
        RUBY
      end

      def validators
        {
          uniqueness: ({ case_sensitive: case_sensitive?, allow_blank: } if unique?),
          presence: required?
        }.compact_blank
      end
    end
  end
end
