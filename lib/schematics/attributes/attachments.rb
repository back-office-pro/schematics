# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
        values.map(&:blob_url)
      end

      def json_default = [super]

      def open_api_body_type = [super]

      def open_api_schema_type = [super]

      def open_api_query_type = super.first

      def permitted_json_params = permitted_params

      def permitted_params = [
        { super.first => [] },
        super.second
      ]

      def input_name = "#{super}[]"

      def search_column = :"#{search_column_association}_filename"

      def search_column_association = "#{name}_blobs"

      def validators = super.merge(
        limit: {
          min: options.min,
          max: options.max
        }
      )

      private

      def attached_method = :has_many_base64_attached
    end
  end
end
