module Schematics
  module Associations
    class Association
      attr_reader :belongs_to
      delegate :entity, :required?, to: :@belongs_to
      delegate :descriptor, :class_name, :icon, to: :entity

      class << self
        def create(belongs_to, type:, **args)
          Associations.const_get(type.camelize.to_sym).new(belongs_to)
        end
      end

      def initialize(belongs_to)
        @belongs_to = belongs_to
      end

      def type
        self.class.name.demodulize.underscore
      end

      def name
        belongs_to.inverse_association_name
      end

      def to_str
        <<~RUBY
          #{type} :#{name},
                  class_name: '#{class_name}',
                  foreign_key: '#{belongs_to.column_name}'
        RUBY
      end
    end
  end
end
