# frozen_string_literal: true

module Schematics
  module Viewer
    module Pagination
      class Component < ApplicationComponent
        delegate :pagy_items_selector_js, :pagy_info, :pagy_bootstrap_nav, to: :helpers
        delegate :pages, to: :@pagy

        def initialize(pagy:, calendar: nil, human_name_plural: nil)
          super
          @pagy = pagy
          @calendar = calendar
          @human_name_plural = human_name_plural
        end

        def render?
          @calendar.present? || pages > 1
        end

        def nav_parameter
          @calendar&.fetch(:month) || @pagy
        end
      end
    end
  end
end
