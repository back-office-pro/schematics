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
  module Searchable
    extend ActiveSupport::Concern

    included do
      scope :autocomplete, AutocompleteQuery.new(self) # rubocop:disable Rails/ScopeArgs
      scope :list, ListQuery.new(self) # rubocop:disable Rails/ScopeArgs
    end

    class_methods do
      def ransackable_attributes(*)
        entity
          .searchable_fields
          .map(&:name)
      end

      def ransackable_associations(*)
        entity
          .searchable_associations
          .map(&:name)
          .concat(entity.rich_text_attributes.map(&:search_column_association))
          .concat(entity.attachment_attributes.map(&:search_column_association))
      end

      def ransortable_attributes(*)
        entity
          .searchable_elements
          .map(&:name)
      end

      def ransackable_scopes(*)
        %i[with_deleted]
      end
    end
  end
end
