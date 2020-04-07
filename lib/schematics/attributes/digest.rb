module Schematics
  module Attributes
    class Digest < String
      def api_param_type
        "string"
      end

      def permitted_param
        [super, "#{super}_confirmation"]
      end

      def validators
        super.merge(allow_nil: true)
      end

      def to_str
        <<~RUBY
          has_secure_password :#{@name}
        RUBY
      end

      def visible?
        false
      end

      def searchable?
        false
      end

      def default
        SecureRandom.base58
      end
    end
  end
end
