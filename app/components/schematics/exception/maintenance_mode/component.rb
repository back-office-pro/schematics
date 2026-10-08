# frozen_string_literal: true

module Schematics
  module Exception
    module MaintenanceMode
      class Component < ApplicationComponent
        def icon = :person_digging

        def title = t('titles.schematics.exception.maintenance_mode')
      end
    end
  end
end
