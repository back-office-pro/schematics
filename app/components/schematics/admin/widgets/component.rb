# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      class Component < ApplicationComponent
        delegate :entity, to: :model_class, private: true
        delegate :icon, to: :entity

        def caption = t('.caption')

        def title = t('.title')

        def path = resources_path(model_class)

        def render?
          can?(action, model_class)
        end

        protected

        def model_class = self
          .class
          .module_parent_name
          .demodulize
          .singularize
          .constantize

        def action = :index
      end
    end
  end
end
