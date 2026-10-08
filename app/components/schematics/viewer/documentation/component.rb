# frozen_string_literal: true

module Schematics
  module Viewer
    module Documentation
      class Component < ApplicationComponent
        delegate :entity, to: :model_class
        delegate :core?, to: :entity, private: true

        option :model_class

        def icon = :book

        def title = t('.title')

        def render?
          !core?
        end
      end
    end
  end
end
