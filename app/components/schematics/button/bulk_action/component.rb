# frozen_string_literal: true

module Schematics
  module Button
    module BulkAction
      class Component < ApplicationComponent
        option :model_class

        def title = t('.text')

        def render?
          can?(:archive, model_class)
        end
      end
    end
  end
end
