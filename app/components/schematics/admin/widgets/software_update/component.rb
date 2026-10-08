# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module SoftwareUpdate
        class Component < ApplicationComponent
          def icon = :spinner

          def data = { 'software-update-target': 'icon' }

          def url = 'https://hub.docker.com/r/backofficeapp/back-office/tags'

          def version = VERSION
        end
      end
    end
  end
end
