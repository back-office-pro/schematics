module Schematics
  module Associations
    class AssociationThrough < Association
      attr_accessor :through

      def initialize(reference, through)
        super(reference)
        @through = through
      end

      def type
        super.chomp('_through')
      end

      def to_str
        super.squish + ", through: :#{@through.name}"
      end
    end
  end
end
