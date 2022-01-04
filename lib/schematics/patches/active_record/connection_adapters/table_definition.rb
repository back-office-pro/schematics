# frozen_string_literal: true

module Schematics
  module Patches
    module ActiveRecord
      module ConnectionAdapters
        module TableDefinition
          def timestamps(**options)
            super
            column(:deleted_at, :datetime, **options)
          end
        end
      end
    end
  end
end
