require 'schematics/attributes/attribute'

module Schematics
  module Attributes
    class Digest < Attribute
      include Behaviours::Fillable

      def permitted_params
        [super, :"#{super}_confirmation"]
      end

      def validators
        validators = super
        validators[:allow_nil] = true
        validators[:length] = { minimum: @options[:min] } if @options.key?(:min)
        validators[:length] = { maximum: @options[:limit] } if @options.key?(:limit)
        if @options.key?(:min) && @options.key?(:limit)
          validators[:length] = { in: @options[:min]..@options[:limit] }
        end
        validators[:length] = { is: @options[:length] } if @options.key?(:length)
        validators
      end

      def to_str
        <<~RUBY
          has_secure_password :#{@name}
        RUBY
      end

      def default
        @default ||= SecureRandom.base58
      end

      def icon
        :key
      end
    end
  end
end
