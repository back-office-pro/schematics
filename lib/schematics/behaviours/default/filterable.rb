module Schematics
  module Behaviours
    module Default
      module Filterable
        def filter_scope
          super.extends <<~RUBY
            #{name} { where(#{name}: #{name}) }
          RUBY
        end
      end
    end
  end
end
