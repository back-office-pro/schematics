# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module TemplateInterpolation
    class Component < ApplicationComponent
      delegate :interpolation_errors, to: :template
      option :template
      option :resource

      def interpolation
        template.interpolate(resource)
      end
    end
  end
end
