# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Licence
        class Component < ApplicationComponent
          delegate :icon, to: 'Core::Licence.entity'

          def resource
            @resource ||= Core::Licence.instance
          end

          def target = 'confirm-dialog-cancel-licence'

          def render?
            can?(:cancel, Core::Licence)
          end
        end
      end
    end
  end
end
