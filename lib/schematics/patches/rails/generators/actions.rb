module Schematics
  module Patches
    module Rails
      module Generators
        module Actions
          def route(routing_code, namespace: nil)
            routing_code = routing_code.extends_with_comma <<~RUBY
              path_names: { new: :new, edit: :edit }
            RUBY

            routing_code = Array(namespace).reverse.reduce(routing_code) do |code, ns|
              "namespace :#{ns} do\n#{indent(code, 2)}\nend"
            end

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
