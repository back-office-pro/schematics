require 'active_support/core_ext/module/delegation'

module Schematics
  module Associations
    class Association
      delegate :entity, :required?, :column_name, to: :belongs_to
      delegate :descriptor, :class_name, :icon, to: :entity
      attr_reader :belongs_to

      class << self
        def create(belongs_to, type:, name: nil)
          unless belongs_to.is_a?(Attributes::Association)
            belongs_to = create_belongs_to(belongs_to, name, type)
          end
          Associations.const_get(type.camelize.to_sym).new(belongs_to)
        end

        private

        def create_belongs_to(entity, name, type)
          Attributes::BelongsTo.new(
            entity,
            name,
            options: {
              required: true,
              inverse: {
                type: type,
              },
            }
          )
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
                  foreign_key: '#{column_name}'
        RUBY
      end

      def weight
        3
      end
    end
  end
end
