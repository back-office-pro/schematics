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
  module SearchIndexes
    class AutocompleteQuery < ApplicationQuery
      LIMIT = 5

      def call(*, ability, query)
        where("#{table_name} MATCH ?", query.to_json)
          .select(:searchable_id, :searchable_type)
          .order(:rank)
          .map { it.searchable_type.safe_constantize&.preload_all&.where(id: it.searchable_id) }
          .filter_map { it.accessible_by(ability) }
          .compact_blank
          .flatten
          .take(LIMIT)
      end
    end
  end
end
