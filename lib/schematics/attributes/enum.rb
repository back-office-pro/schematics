require 'schematics/attributes/attribute'
require 'schematics/behaviours/listable'
require 'schematics/behaviours/renderable'
require 'schematics/behaviours/searchable'
require 'schematics/behaviours/fillable'
require 'schematics/behaviours/editable'

module Schematics
  module Attributes
    class Enum < Attribute
      include Behaviours::Listable
      include Behaviours::Renderable
      include Behaviours::Searchable
      include Behaviours::Fillable
      include Behaviours::Editable

      def values
        @options[:values]
      end

      def validators
        super.merge(inclusion: { in: values }, allow_nil: !required?)
      end

      def type
        'integer'
      end

      def to_str
        if default.nil?
          <<~RUBY
            enum #{@name}: #{to_h}, _prefix: true
          RUBY
        else
          <<~RUBY
            enum #{@name}: #{to_h}, _prefix: true, _default: "#{default}"
          RUBY
        end
      end

      def format(value)
        return unless value
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
        values.collect { |value| [value, format(value)] }
      end

      private

      def to_h
        values
          .map(&:to_sym)
          .map
          .with_index
          .to_h
      end
    end
  end
end
