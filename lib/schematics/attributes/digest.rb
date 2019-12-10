module Schematics
  module Attributes
    class Digest < String
      def permitted_param
        [super, "#{super}_confirmation"]
      end

      def scope
        nil
      end

      def has_scope
        nil
      end

      def to_str
        %Q[has_secure_password]
      end
    end
  end
end
