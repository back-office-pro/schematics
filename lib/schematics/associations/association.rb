module Schematics
  module Associations
    class Association
      include Renderable

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

      def descriptor
        entity.descriptor
      end

      def filter_scope
        %Q[scope :by_#{name}, -> ]
      end

      def sort_scope
        %Q[scope :sort_by_#{name}, -> ]
      end

      def has_filter_scope
        %Q[has_scope :by_#{name}, only: :index]
      end

      def has_sort_scope
        %Q[has_scope :sort_by_#{name}, only: :index]
      end

      def to_str
        "#{type} :#{name}, class_name: '#{class_name}', foreign_key: '#{reference.column_name}'"
      end

      def icon
        :link
      end
    end
  end
end
