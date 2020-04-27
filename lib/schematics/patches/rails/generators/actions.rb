module Schematics
  module Patches
    module Rails
      module Generators
        module Actions
          def route(routing_code)
            log :route, routing_code
            sentinel = "\n\s\send"

            in_root do
              inject_into_file "config/routes.rb",
                               "\n#{optimize_indentation(routing_code, 4).gsub("\n", "")}",
                               before: sentinel,
                               verbose: false,
                               force: false
            end
          end
        end
      end
    end
  end
end
