# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Viewer
    module Kanban
      class Component < Viewer::Component
        delegate :values, :format, to: :attribute

        def elements = super.excluding(attribute)

        def attribute = entity
          .enum_attributes
          .first

        def groups
          resources.group_by(&attribute.name.to_sym)
        end

        def tbody_css_classes
          params[:page].presence && super
        end

        def card_css_class(resource)
          class_names('sortable-disabled': cannot?(:edit, resource))
        end
      end
    end
  end
end
