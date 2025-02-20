# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module EditInPlace
    class Component < ApplicationComponent
      option :resource
      option :element

      def frame_id = dom_id(resource, element.name)

      def url = resource_path(resource)
    end
  end
end
