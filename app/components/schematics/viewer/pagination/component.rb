# frozen_string_literal: true

module Schematics
  module Viewer
    module Pagination
      class Component < ApplicationComponent
        delegate :pages, to: :pagy
        option :pagy
        option :calendar, optional: true
        option :human_name_plural, optional: true

        def css_classes
          'mb-3' if calendar && pages > 1
        end

        def render?
          calendar.presence || pages > 1
        end
      end
    end
  end
end
