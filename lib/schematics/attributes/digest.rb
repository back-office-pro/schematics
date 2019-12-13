module Schematics
  module Attributes
    class Digest < String
      def api_param_type
        "string"
      end

      def permitted_param
        [super, "#{super}_confirmation"]
      end

      def scope
        nil
      end

      def has_scope
        nil
      end

      def validators
        super.merge(allow_nil: true)
      end

      def to_str
        %Q[has_secure_password :#{@name}]
      end
    end
  end
end
