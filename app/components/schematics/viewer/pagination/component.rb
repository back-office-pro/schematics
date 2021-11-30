# frozen_string_literal: true

module Schematics
  module Viewer
    module Pagination
      class Component < ApplicationComponent
        delegate :pagy_items_selector_js, :pagy_bootstrap_nav_js, :pagy_info, to: :helpers
        delegate :viewer, to: :@entity
        delegate :pages, to: :@pagy

        def initialize(entity:, pagy:)
          super
          @entity = entity
          @pagy = pagy
        end

        def render?
          %i[table grid inbox].include?(viewer) && pages > 1
        end

        def item_name
          @entity
            .class_name
            .constantize
            .model_name
            .human
            .pluralize
            .downcase
        end
      end
    end
  end
end
