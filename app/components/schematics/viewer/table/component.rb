# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Viewer
    module Table
      class Component < Viewer::Component
        def table_css_classes
          %w[table-striped table-hover] if resources.any?
        end

        def tbody_css_classes
          params[:page].presence && super
        end
      end
    end
  end
end
