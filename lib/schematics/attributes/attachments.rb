module Schematics
  module Attributes
    class Attachments < Attachment
      def api_param_type
        "array"
      end

      def permitted_param
        { super => [] }
      end

      def permitted_json_param
        permitted_param
      end

      def default
        [super]
      end

      def json_default
        [super]
      end

      def format(value)
        value.map do |attachment|
          Rails.application.routes.url_helpers.url_for(attachment)
        end
      end

      def to_str
        <<~RUBY
          has_many_base64_attached :#{@name}
        RUBY
      end
    end
  end
end
