# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Navbar
    module BreadcrumbTrail
      module Breadcrumb
        class Component < ApplicationComponent
          delegate :last?, to: :@iteration
          with_collection_parameter :breadcrumb

          def initialize(breadcrumb:, breadcrumb_iteration:)
            super
            @title, @path = breadcrumb
            @iteration = breadcrumb_iteration
          end

          def css_classes = class_names(active: last?)
        end
      end
    end
  end
end
