module Schematics
  module Associations
    class Association
      attr_accessor :reference
      
      def initialize(reference)
        @reference = reference
      end

      def type
        self.class.name.demodulize.underscore
      end

      def name
        reference.inverse_association_name
      end

      def class_name
        entity.type.camelize
      end

      def entity
        @reference.entity
      end

      def required?
        @reference.required?
      end

      def scope
        %Q[scope :by_#{name}, -> ]
      end
      
      def has_scope
        %Q[has_scope :by_#{name}, only: :index]
      end

      def to_str
        "#{type} :#{name}, class_name: '#{class_name}', foreign_key: '#{reference.column_name}'"
      end
    end
  end
end
