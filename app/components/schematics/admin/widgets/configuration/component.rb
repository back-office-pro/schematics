# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Configuration
        class Component < Widgets::Component
          def path = edit_resource_path(::Configuration.instance)

          protected

          def action = :update
        end
      end
    end
  end
end
