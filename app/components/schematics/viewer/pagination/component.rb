# frozen_string_literal: true

module Schematics
  module Viewer
    module Pagination
      class Component < ApplicationComponent
        delegate :pages, to: :@pagy

        def initialize(pagy:, calendar: nil, human_name_plural: nil)
          super
          @pagy = pagy
          @calendar = calendar
          @human_name_plural = human_name_plural
        end

        def nav_parameter
          @calendar&.fetch(:month) || @pagy
        end

        def render?
          @calendar.presence || pages > 1
        end
      end
    end
  end
end
