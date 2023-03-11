# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Licence
        class Component < ApplicationComponent
          delegate :icon, to: '::Licence.entity'

          def resource
            @resource ||= ::Licence.instance
          end

          def target = 'confirm-dialog-cancel-licence'

          def render?
            can?(:cancel, ::Licence)
          end
        end
      end
    end
  end
end
