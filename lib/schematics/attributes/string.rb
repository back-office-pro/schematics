module Schematics
  module Attributes
    class String < Text
      def validators
        validators = super
        validators[:length] = { minimum: @options[:min] } if @options.key?(:min)
        validators[:length] = { maximum: @options[:limit] } if @options.key?(:limit)
        validators[:length] = { in: @options[:min]..@options[:limit] } if @options.key?(:min) && @options.key?(:limit)
        validators[:length] = { is: @options[:length] } if @options.key?(:length)
        validators[:format] = { with: URI::MailTo::EMAIL_REGEXP } if @options[:email]
        validators
      end
    end
  end
end
