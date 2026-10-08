# frozen_string_literal: true

module Schematics
  module Viewer
    module Grid
      class Component < Viewer::Component
        def tbody_css_classes
          params[:page].presence && super
        end

        def groups = resources
          .to_a
          .in_groups_of(3, false)
      end
    end
  end
end
