# frozen_string_literal: true

module Schematics
  module Exception
    module UnsupportedBrowser
      class Component < ApplicationComponent
        def icon = :window_restore

        def title = t('titles.schematics.exception.unsupported_browser')
      end
    end
  end
end
