module Schematics
  module Patches
    module Ransack
      module Nodes
        module Sort
          # TODO
          # Handle aliases on sort
          # Remove when https://github.com/activerecord-hackery/ransack/pull/1084 is merged
          def name=(name)
            super context.ransackable_alias(name) || name
          end
        end
      end
    end
  end
end
