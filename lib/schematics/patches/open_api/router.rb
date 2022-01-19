# frozen_string_literal: true

module Schematics
  module Patches
    module OpenApi
      module Router
        def routes
          ::Rails.application.reload_routes!
          super +
            ActionDispatch::Routing::RoutesInspector
            .new(Schematics::Engine.routes.routes)
            .format(ActionDispatch::Routing::ConsoleFormatter::Sheet.new)
        end
      end
    end
  end
end
