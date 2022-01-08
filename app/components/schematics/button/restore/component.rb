# frozen_string_literal: true

module Schematics
  module Button
    module Restore
      class Component < ApplicationComponent
        delegate :can?, to: :helpers

        def initialize(resource:)
          super
          @resource = resource
        end

        def render?
          can?(:restore, @resource)
        end
      end
    end
  end
end
