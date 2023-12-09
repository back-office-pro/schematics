# frozen_string_literal: true

module Schematics
  module Button
    module Compare
      class Component < ApplicationComponent
        option :model_class

        def title = t('.text')

        def render?
          can?(:create, ::Comparison) && can?(:show, model_class)
        end
      end
    end
  end
end
