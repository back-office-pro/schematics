# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Viewer
    module Pagination
      class Component < ApplicationComponent
        delegate :pages, :limit_tag_js, :info_tag, :series_nav, to: :pagy
        option :pagy
        option :calendar, optional: true
        option :human_name_plural, optional: true

        def css_classes
          'mb-3' if calendar? && pages?
        end

        def pages?
          pages > 1
        end

        def calendar?
          calendar.present?
        end

        def render?
          calendar? || pages?
        end
      end
    end
  end
end
