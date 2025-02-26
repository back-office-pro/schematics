# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Button
    module Compare
      class Component < ApplicationComponent
        delegate :icon, to: 'current_module::Comparison.entity'
        option :model_class

        def title = t('.text')

        def icon_class = 'fa-fw fa-lg'

        def render?
          can?(:create, current_module::Comparison) && can?(:show, model_class)
        end
      end
    end
  end
end
