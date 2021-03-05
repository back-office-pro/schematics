require 'schematics/associations/association'

module Schematics
  module Associations
    class HasMany < Association
      def name
        super.pluralize
      end

      def to_str
        super
          .chomp
          .concat(', ')
          .concat <<~RUBY
            inverse_of: :#{belongs_to.name},
            dependent: :#{dependent}
          RUBY
      end

      private

      def dependent
        return :destroy if required?
        :nullify
      end
    end
  end
end
