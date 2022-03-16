# frozen_string_literal: true

module Schematics
  module Attributes
    class Attachments < Attachment
      def open_api_type
        'array'
      end

      def permitted_params
        [
          { super.first => [] },
          super.second
        ]
      end

      def permitted_json_params
        permitted_params
      end

      def default
        [super]
      end

      def json_default
        [super]
      end

      def search_data
        <<~RUBY
          #{name}.map(&:filename).map(&:to_s).map(&:downcase)
        RUBY
      end

      def format(value)
        value.map do |attachment|
          Rails.application.routes.url_helpers.url_for(attachment)
        end
      end

      def to_str
        <<~RUBY
          has_many_base64_attached :#{name}
          accepts_nested_attributes_for :#{association_name},
                                        allow_destroy: true,
                                        reject_if: :all_blank
        RUBY
      end
    end
  end
end
