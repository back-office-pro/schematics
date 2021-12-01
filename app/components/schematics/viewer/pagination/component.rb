# frozen_string_literal: true

module Schematics
  module Viewer
    module Pagination
      class Component < ApplicationComponent
        delegate :pagy_items_selector_js, :pagy_info, :pagy_bootstrap_nav, to: :helpers
        delegate :viewer, to: :@entity
        delegate :pages, to: :@pagy

        def initialize(entity:, pagy:, calendar:)
          super
          @entity = entity
          @pagy = pagy
          @calendar = calendar
        end

        def render?
          @calendar.present? || pages > 1
        end

        def nav_parameter
          @calendar&.fetch(:month) || @pagy
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
