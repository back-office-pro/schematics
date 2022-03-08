# frozen_string_literal: true

module Schematics
  module Button
    module Duplicate
      class Component < ApplicationComponent
        delegate :can?, to: :helpers

        def initialize(resource:)
          super
          @resource = resource
        end

        def render?
          can?(:duplicate, @resource)
        end
      end
    end
  end
end
