require 'schematics/associations/association'

module Schematics
  module Associations
    class AssociationThrough < Association
      attr_reader :through

      def initialize(belongs_to, through)
        super(belongs_to)
        @through = through
      end

      def type
        super.chomp('_through')
      end

      def to_str
        super
          .chomp
          .concat(', ')
          .concat <<~RUBY
            through: :#{@through.name}
          RUBY
      end
    end
  end
end
