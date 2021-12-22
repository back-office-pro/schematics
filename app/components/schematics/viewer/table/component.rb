# frozen_string_literal: true

module Schematics
  module Viewer
    module Table
      class Component < Viewer::Component
        def table_css_classes
          return %w[table-striped table-hover] if @resources.any?
        end

        def tbody_css_classes
          params[:page] && super
        end

        def tr_css_class(resource)
          return 'disabled' if resource.deleted?
          return 'font-weight-bold' if resource.unread?
        end
      end
    end
  end
end
