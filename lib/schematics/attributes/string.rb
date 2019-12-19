module Schematics
  module Attributes
    class String < Text
      def migration_options
        super + [:email, :url, :phone]
      end

      def email?
        @options[:email]
      end

      def url?
        @options[:url]
      end

      def phone?
        @options[:phone]
      end

      def validators
        validators = super
        validators[:length] = { minimum: @options[:min] } if @options.key?(:min)
        validators[:length] = { maximum: @options[:limit] } if @options.key?(:limit)
        validators[:length] = { in: @options[:min]..@options[:limit] } if @options.key?(:min) && @options.key?(:limit)
        validators[:length] = { is: @options[:length] } if @options.key?(:length)
        validators[:email]  = true if email?
        validators[:phone]  = true if phone?
        validators[:url]    = true if url?
        validators
      end
    end
  end
end
