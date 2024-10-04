# frozen_string_literal: true

module Schematics
  module Navbar
    module BreadcrumbTrail
      module Breadcrumb
        class Component < ApplicationComponent
          delegate :last?, to: :@breadcrumb_iteration
          with_collection_parameter :breadcrumb

          def initialize(breadcrumb:, breadcrumb_iteration:)
            super
            @title, @path = breadcrumb
            @breadcrumb_iteration = breadcrumb_iteration
          end

          def css_classes = class_names(active: last?)
        end
      end
    end
  end
end
