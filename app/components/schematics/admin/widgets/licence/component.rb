# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Licence
        class Component < ApplicationComponent
          delegate :icon, to: '::Licence.entity'

          def model
            @model ||= mod::Licence.instance
          end

          def target = 'confirm-dialog-cancel-licence'
        end
      end
    end
  end
end
