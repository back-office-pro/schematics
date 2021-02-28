require 'schematics/attributes/attribute'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/fillable'
require 'schematics/behaviours/editable'

module Schematics
  module Attributes
    class Enum < Attribute
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Editable

      attr_reader :values

      def initialize(entity, name, options)
        super(entity, name, { default: 0 })
        @values = options
      end

      def validators
        super.merge(inclusion: { in: @values })
      end

      def type
        'integer'
      end

      def to_str
        <<~RUBY
          enum #{@name}: #{@values.map(&:to_sym).map.with_index.to_h}, _prefix: true
        RUBY
      end

      def format(value)
        I18n.t value.to_sym,
               default: value.humanize,
               scope: [:activerecord, :attributes, @entity.class_name.underscore, @name.pluralize]
      end

      def icon
        :list_ol
      end

      def input_type
        :select
      end

      def input_collection
        @values.collect { |value| [value, format(value)] }
      end
    end
  end
end
