# frozen_string_literal: true

module Schematics
  module Button
    module Archive
      class Component < ApplicationComponent
        delegate :can?, to: :helpers

        def initialize(resource:)
          super
          @resource = resource
        end

        def render?
          can?(:archive, @resource)
        end
      end
    end
  end
end
