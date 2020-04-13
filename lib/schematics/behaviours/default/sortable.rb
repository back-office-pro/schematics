module Schematics
  module Behaviours
    module Default
      module Sortable
        def sort_scope
          super.extends <<~RUBY
            sort_direction { order(#{name}: sort_direction) }
          RUBY
        end
      end
    end
  end
end
