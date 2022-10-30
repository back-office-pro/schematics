# frozen_string_literal: true

module Schematics
  module Patches
    module ActiveRecord
      module ConnectionAdapters
        module TableDefinition
          def timestamps(*)
            column(:created_at, :datetime, null: false, index: { where: 'deleted_at IS NULL' })
            column(:updated_at, :datetime, null: false)
            column(:deleted_at, :datetime)
          end
        end
      end
    end
  end
end
