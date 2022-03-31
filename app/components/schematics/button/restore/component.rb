# frozen_string_literal: true

module Schematics
  module Button
    module Restore
      class Component < ApplicationComponent
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
