module Schematics
  module Attributes
    class Digest < String
      def api_param_type
        "string"
      end

      def permitted_param
        [super, "#{super}_confirmation"]
      end

      def filter_scope
        nil
      end

      def sort_scope
        nil
      end

      def has_filter_scope
        nil
      end

      def has_sort_scope
        nil
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
