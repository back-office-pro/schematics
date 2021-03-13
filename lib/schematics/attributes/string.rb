require 'schematics/attributes/text'
require 'schematics/behaviours/listable'

module Schematics
  module Attributes
    class String < Text
      include Behaviours::Listable

      def type
        'string'
      end

      def validators
        validators = super
        validators[:length] = { minimum: @options[:min] } if @options.key?(:min)
        validators[:length] = { maximum: @options[:limit] } if @options.key?(:limit)
        if @options.key?(:min) && @options.key?(:limit)
          validators[:length] = { in: @options[:min]..@options[:limit] }
        end
        validators
      end

      def default
        return SecureRandom.base58 if unique?
        super
      end

      def input_type
        :input
      end

      def format(value)
        value.to_s
      end
    end
  end
end
