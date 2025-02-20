# Copyright © 2025 Dev & Software. All rights reserved.
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
