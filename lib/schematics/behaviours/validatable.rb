# frozen_string_literal: true

require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/module/delegation'

module Schematics
  module Behaviours
    module Validatable
      delegate :unique?, :required?, :case_sensitive?, to: :options

      def validate
        return if validators.empty?

        <<~RUBY
          validates :#{name}, #{validators}
        RUBY
      end

      def validators
        {
          uniqueness: ({ case_sensitive: case_sensitive?, allow_blank: !required? } if unique?),
          presence: required?
        }.compact_blank
      end
    end
  end
end
