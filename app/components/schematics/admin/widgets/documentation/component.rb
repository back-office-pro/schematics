# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Documentation
        class Component < Widgets::Component
          def path = Schematics::Engine
            .routes
            .url_helpers
            .documentation_path

          def icon = :book

          def model_class = ::ApiKey
        end
      end
    end
  end
end
