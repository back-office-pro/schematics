module Schematics
  module Patches
    module Rails
      module Generators
        module Actions
          def route(routing_code)
            log :route, routing_code
            in_root do
              inject_into_file "config/routes.rb", "\n#{optimize_indentation(routing_code, 2).gsub("\n", "")}", before: "\nend", verbose: false, force: false
            end
          end
        end
      end
    end
  end
end
