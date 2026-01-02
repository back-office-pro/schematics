# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Rails
  module Override
    module Generators
      module GeneratedAttribute
        def valid_type?(*) = true

        def inject_index_options = [super, inject_index_type, inject_index_where]
          .compact
          .join(', ')

        def options_for_migration
          return {} unless reference?

          { index: { where: 'deleted_at IS NULL' }, polymorphic: polymorphic? }.compact_blank
        end

        private

        def inject_index_type
          return 'using: :gin' if type == :jsonb

          'using: :btree'
        end

        def inject_index_where
          "where: 'deleted_at IS NULL'" unless index_name in Array
        end
      end
    end
  end
end
