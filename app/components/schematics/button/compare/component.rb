# frozen_string_literal: true

module Schematics
  module Button
    module Compare
      class Component < ApplicationComponent
        delegate :can?, to: :helpers

        def render?
          can?(:create, ::Comparison)
        end
      end
    end
  end
end
