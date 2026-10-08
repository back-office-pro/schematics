# frozen_string_literal: true

module Schematics
  module Viewer
    module Specifications
      module Section
        class Component < ApplicationComponent
          with_collection_parameter :element

          def initialize(element:, indent: 0, options: false, icon: nil, item_class: nil)
            super
            @element = element
            @indent = indent
            @options = options
            @icon = icon || element.icon
            @item_class = item_class
          end

          def interpolate(element)
            element
              .to_spec
              .gsub(/\*\*(.*?)\*\*/, '<b>\1</b>')
              .gsub(/\*(.*?)\*/, '<i>\1</i>')
              .gsub(/`(.+)`/, '<code>\1</code>')
          end
        end
      end
    end
  end
end
