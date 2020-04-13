module Schematics
  module Associations
    class Association
      attr_accessor :belongs_to
      delegate :entity, :required?, to: :@belongs_to
      delegate :descriptor, to: :entity

      def initialize(belongs_to)
        @belongs_to = belongs_to
      end

      def type
        self.class.name.demodulize.underscore
      end

      def name
        belongs_to.inverse_association_name
      end

      def class_name
        entity.type.camelize
      end

      def to_str
        <<~RUBY
          #{type} :#{name},
                  class_name: '#{class_name}',
                  foreign_key: '#{belongs_to.column_name}'
        RUBY
      end

      def icon
        :link
      end
    end
  end
end
