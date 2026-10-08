# frozen_string_literal: true

module Schematics
  module Button
    module Compare
      class Component < ApplicationComponent
        delegate :icon, to: '::Comparison.entity'
        option :model_class

        def title = t('.text')

        def icon_class = 'fa-lg'

        def render?
          can?(:create, ::Comparison) && can?(:show, model_class)
        end
      end
    end
  end
end
