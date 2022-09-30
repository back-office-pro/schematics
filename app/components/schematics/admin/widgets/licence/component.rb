# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Licence
        class Component < ApplicationComponent
          delegate :name, to: 'Schematics::Licence.instance'

          def icon = :id_badge

          def target = 'confirm-dialog-cancel-licence'
        end
      end
    end
  end
end
