module Schematics
  module Attributes
    class Token < Attribute
      def unique?
        true
      end

      def api_param_type
        "string"
      end

      def permitted_param
        nil
      end

      def default
        SecureRandom.base58
      end

      def to_str
        <<~RUBY
          has_secure_token :#{@name}
        RUBY
      end

      def visible?
        false
      end
    end
  end
end
