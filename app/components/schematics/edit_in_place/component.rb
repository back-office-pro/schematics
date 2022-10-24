# frozen_string_literal: true

module Schematics
  module EditInPlace
    class Component < ApplicationComponent
      option :resource
      option :field

      def frame_id = dom_id(resource, field.name)
    end
  end
end
