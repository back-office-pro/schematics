# frozen_string_literal: true

module Schematics
  module Attributes
    class Attachments < Attachment
      def default = [super]

      def format(value)
        value.map do |attachment|
          Rails.application.routes.url_helpers.url_for(attachment)
        end
      end

      def json_default = [super]

      def open_api_type = [super]

      def permitted_json_params = permitted_params

      def permitted_params = [
        { super.first => [] },
        super.second
      ]

      def search_data = <<~RUBY
        #{name}: #{name}.map(&:filename).map(&:to_s).map(&:downcase)
      RUBY

      def to_str = <<~RUBY
        has_many_base64_attached :#{name}
        accepts_nested_attributes_for :#{association_name},
                                      allow_destroy: true,
                                      reject_if: :all_blank
      RUBY
    end
  end
end
