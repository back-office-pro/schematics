# frozen_string_literal: true

module Schematics
  module Exception
    module Offline
      class Component < ApplicationComponent
        def icon = :signal

        def title = t('titles.schematics.exception.offline')
      end
    end
  end
end
