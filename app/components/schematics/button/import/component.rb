# frozen_string_literal: true

module Schematics
  module Button
    module Import
      class Component < ApplicationComponent
        delegate :human_name_plural, to: :model_class
        delegate :icon, to: 'mod::Import.entity'
        option :model_class

        def css_classes = %w[btn btn-sm btn-icon-split ms-2]

        def render?
          can?(:import, model_class)
        end
      end
    end
  end
end
