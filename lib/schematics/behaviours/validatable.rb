# frozen_string_literal: true

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

      def validators
        Schematics::Validators.new(
          name:,
          validators: {
            uniqueness: ({ case_sensitive: case_sensitive?, allow_blank: } if unique?),
            presence: required?
          }
        )
      end
    end
  end
end
