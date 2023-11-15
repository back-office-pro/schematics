# frozen_string_literal: true

module Schematics
  module Viewer
    module Specifications
      module Section
        class Component < ApplicationComponent
          with_collection_parameter :element

          def initialize(element:)
            super
            @element = element
          end

          def options
            @element.try(:options) || []
          end

          def icon
            @element.try(:icon) || :atom
          end

          def indent
            @element.respond_to?(:entity) ? 1 : 0
          end

          def value_formatted = @element
            .to_spec
            .gsub(/\*\*(.*?+)\*\*/, '<b>\1</b>')
            .gsub(/\*(.*?+)\*/, '<i>\1</i>')
            .gsub(/`(.+)`/, '<code>\1</code>')
        end
      end
    end
  end
end
