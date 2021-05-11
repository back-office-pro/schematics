require 'active_support/core_ext/enumerable'

module Schematics
  module Behaviours
    module Validatable
      def required?
        options[:required] || unique?
      end

      def unique?
        options[:unique]
      end

      def validate
        return if validators.empty?
        <<~RUBY
          validates :#{name}, #{validators}
        RUBY
      end

      def validators
        {
          uniqueness: ({ case_sensitive: false } if unique?),
          presence: required?,
        }.compact
      end
    end
  end
end
