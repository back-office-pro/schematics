require 'schematics/associations/association'

module Schematics
  module Associations
    class HasMany < Association
      def name
        super.pluralize
      end

      def to_str
        super.squish + ', ' + <<~RUBY # rubocop:disable Style/StringConcatenation
          dependent: :#{dependent_method}
        RUBY
      end

      private

      def dependent_method
        required? ? :destroy : :nullify
      end
    end
  end
end
