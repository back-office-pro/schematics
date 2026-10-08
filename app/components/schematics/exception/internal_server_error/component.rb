# frozen_string_literal: true

module Schematics
  module Exception
    module InternalServerError
      class Component < ApplicationComponent
        def icon = :bomb

        def title = t('titles.schematics.exception.internal_server_error')
      end
    end
  end
end
