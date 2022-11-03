# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Behaviours
    module Validatable
      delegate :unique?, :required?, to: :options

      def allow_blank = !required?

      def available_options = [
        Options::Required,
        Options::Hidden,
        Options::Cached
      ]

      def case_sensitive? = true

      def validators = Schematics::Validators.new(
        name:,
        validators: {
          uniqueness: ({ case_sensitive: case_sensitive?, allow_blank: } if unique?),
          presence: required?
        }
      )
    end
  end
end
