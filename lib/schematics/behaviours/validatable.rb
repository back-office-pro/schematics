# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Behaviours
    module Validatable
      delegate :unique?, :required?, :case_insensitive?, to: :options

      def allow_blank = !required? # rubocop:disable Naming/PredicateMethod

      def available_options = [Options::Required]

      def validators = Schematics::Validators.new(
        name:,
        validators: {
          uniqueness_with_deleted: ({ case_sensitive: !case_insensitive?, allow_blank: } if unique?), # rubocop:disable Layout/LineLength
          presence: required?
        }
      )
    end
  end
end
