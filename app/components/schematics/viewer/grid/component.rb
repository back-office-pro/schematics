# frozen_string_literal: true

module Schematics
  module Viewer
    module Grid
      class Component < Viewer::Component
        def tbody_css_classes
          params[:page].presence && super
        end
      end
    end
  end
end
