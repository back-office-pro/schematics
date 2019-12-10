module Schematics
  module Attributes
    class Token < Attribute
      def scope
        nil
      end

      def has_scope
        nil
      end

      def to_str
        %Q[has_secure_token :#{@name}]
      end
    end
  end
end
