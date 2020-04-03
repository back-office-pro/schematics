module Schematics
  module Attributes
    class Token < Attribute
      def api_param_type
        "string"
      end

      def permitted_param
        nil
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

      def to_str
        %Q(has_secure_token :#{@name})
      end

      def visible?
        false
      end
    end
  end
end
