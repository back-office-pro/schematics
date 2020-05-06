module Schematics
  module Patches
    module Ransack
      module Helpers
        module FormHelper
          module SortLink
            def name
              super.split('&nbsp;').reverse.join.html_safe
            end

            def existing_sort_direction(f = @field)
              super @search.context.ransackable_alias(f)
            end
          end
        end
      end
    end
  end
end
