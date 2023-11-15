# frozen_string_literal: true

module Schematics
  module Viewer
    module Specifications
      module Section
        class Component < ApplicationComponent
          delegate :human_attribute_name, to: 'Schematics::Options::Wrapper'
          with_collection_parameter :element

          def initialize(element:, indent: 0, icon: nil, item_class: nil)
            super
            @element = element
            @indent = indent
            @icon = icon || element.icon
            @item_class = item_class
          end

          def options
            @element.try(:options) || []
          end

          def interpolate(element)
            element
              .to_spec
              .gsub(/\*\*(.*?+)\*\*/, '<b>\1</b>')
              .gsub(/\*(.*?+)\*/, '<i>\1</i>')
              .gsub(/`(.+)`/, '<code>\1</code>')
          end
        end
      end
    end
  end
end
