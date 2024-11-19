# frozen_string_literal: true

module Schematics
  module Dashboard
    module Tab
      class Component < ApplicationComponent
        delegate :first?, to: :@iteration, private: true
        delegate :icon, :title, to: :@dashboard
        with_collection_parameter :dashboard

        def initialize(dashboard:, dashboard_iteration:)
          super
          @dashboard = dashboard
          @iteration = dashboard_iteration
        end

        def css_classes = class_names(active: first?)

        def target = "#dashboard-panel-#{@dashboard.id}"
      end
    end
  end
end
