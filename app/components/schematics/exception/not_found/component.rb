# frozen_string_literal: true

module Schematics
  module Exception
    module NotFound
      class Component < ApplicationComponent
        def icon = :ban

        def title = t('titles.schematics.exception.not_found')
      end
    end
  end
end
