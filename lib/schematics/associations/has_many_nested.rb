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
  module Associations
    class HasManyNested < HasMany
      include Behaviours::Fillable

      def permitted_params = {
        attributes_param_key => [
          entity
            .permitted_params
            .excluding(super)
            .push(:id, :_destroy)
        ]
      }

      def permitted_json_params = {
        attributes_param_key => [
          entity
            .permitted_json_params
            .excluding(super)
            .push(:id, :_destroy)
        ]
      }

      def open_api_body_type = entity
        .open_api_body
        .values
        .map { it.merge(id: 'string', _destroy: 'boolean') }

      def input_name(source_entity = entity)
        "#{source_entity.table_name}[#{attributes_param_key}]"
      end

      def default = [entity.default]

      def to_open_api_body = [attributes_param_key, open_api_body_type]

      def to_str = super.concat(accepts_nested_attributes_for_to_str)

      def attributes_param_key = :"#{name}_attributes"

      private

      def accepts_nested_attributes_for_to_str = <<~RUBY
        accepts_nested_attributes_for :#{name}
      RUBY
    end
  end
end
