module Schematics
  module Attributes
    class Attachments < Attachment
      def api_param_type
        "array"
      end

      def permitted_param
        Hash[super, []]
      end

      def to_str
        %Q(has_many_attached :#{@name})
      end
    end
  end
end
