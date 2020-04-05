module Schematics
  module Patches
    module ActiveRecord
      module ConnectionAdapters
        module TableDefinition
          def timestamps(**options)
            super(**options)
            column(:deleted_at, :datetime)
            column(:slug, :string)
            index(:slug, unique: true)
          end

          # TODO remove when https://github.com/rails/rails/pull/37583 is published
          # Fix this issue: https://github.com/rails/rails/issues/23422
          # Fix: https://stackoverflow.com/questions/51531441/rails-5-2-activestorage-with-uuids-on-postgresql
          # def belongs_to(*args, **options)
          #   super(*args, **options.merge({ type: :uuid }))
          # end

          # def references(*args, **options)
          #   super(*args, **options.merge({ type: :uuid }))
          # end
        end
      end
    end
  end
end
