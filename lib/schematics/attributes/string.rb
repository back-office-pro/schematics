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
        if @options.key?(:min) && @options.key?(:limit)
          validators[:length] = { in: @options[:min]..@options[:limit] }
        end
        validators[:length] = { is: @options[:length] } if @options.key?(:length)
        validators[:email]  = true if email?
        validators[:phone]  = true if phone?
        validators[:url]    = true if url?
        validators
      end

      def default
        return "#{SecureRandom.base58}@#{SecureRandom.base58}.com" if email?
        return Array.new(10) { rand(10) } if phone?
        return "www.#{SecureRandom.base58}.com" if url?
        super
      end
    end
  end
end
