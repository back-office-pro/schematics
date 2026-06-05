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
  module Searches
    class ListQuery < ApplicationQuery
      # :reek:ControlParameter
      def call(filter_params, ability, sort_params = nil)
        preload_all
          .with_string_translations
          .ransack(parse_filter_params(filter_params))
          .tap { it.sorts = parse_sort_params(sort_params) }
          .result
          .references(entity.joins)
          .accessible_by(ability)
      end

      private

      def parse_filter_params(params)
        params
          .deep_flatten
          .transform_keys { entity.find_field_by_name(it)&.search_query || it }
      end

      # :reek:ControlParameter
      def parse_sort_params(params)
        params
          &.split(',')
          &.map { it.start_with?('-') ? "#{it[1..]} desc" : "#{it} asc" } ||
          "#{implicit_order_column} desc"
      end
    end
  end
end
