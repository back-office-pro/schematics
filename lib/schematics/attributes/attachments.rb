# frozen_string_literal: true

module Schematics
  module Attributes
    class Attachments < Attachment
      def available_options = super.push(
        Options::Min,
        Options::Max
      )

      def default = [super]

      def format(values)
        values.map(&Rails.application.routes.url_helpers.method(:url_for))
      end

      def json_default = [super]

      def open_api_type = [super]

      def permitted_json_params = permitted_params

      def permitted_params = [
        { super.first => [] },
        super.second
      ]

      def input_name = "#{super}[]"

      def search_data = <<~RUBY
        #{name}: #{name}.map(&:filename).map(&:to_s).join(',')
      RUBY

      def search_column = :"#{search_column_association}_filename"

      def search_column_association = "#{name}_blobs"

      def validators = super.merge(
        limit: {
          min: options.min,
          max: options.max
        }
      )

      def to_str = <<~RUBY
        has_many_base64_attached :#{name}
        accepts_nested_attributes_for :#{association_name},
                                      allow_destroy: true,
                                      reject_if: :all_blank
      RUBY
    end
  end
end
