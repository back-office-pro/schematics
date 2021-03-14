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
        validators = {}
        validators[:uniqueness] = { case_sensitive: false } if unique?
        validators[:presence] = true if required?
        validators
      end
    end
  end
end
