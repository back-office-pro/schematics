# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'

module Schematics
  module Associations
    class Association
      delegate :entity, :required?, :column_name, :association_type, :options, to: :belongs_to
      delegate :descriptor, :class_name, :icon, to: :entity
      delegate :hidden?, to: :options
      attr_reader :belongs_to
      attr_writer :prefixed

      class << self
        def create(entity_or_belongs_to, type: 'has_many', name: nil)
          constant = Associations.const_get(type.camelize.to_sym)
          case entity_or_belongs_to
          when Entities::Entity
            constant.new(Attributes::BelongsTo.new(entity_or_belongs_to, name, required: true))
          when Attributes::Association
            constant.new(entity_or_belongs_to)
          end
        end
      end

      def initialize(belongs_to)
        @belongs_to = belongs_to
      end

      def type
        self.class.name.demodulize.underscore
      end

      def name
        return [inverse_of, source].join('_') if @prefixed

        source
      end

      def source
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

      protected

      def inverse_of
        belongs_to.name
      end
    end
  end
end
