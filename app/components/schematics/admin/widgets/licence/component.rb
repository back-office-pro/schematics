# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Licence
        class Component < ApplicationComponent
          delegate :icon, to: '::Licence.entity'

          def model
            @model ||= ::Licence.instance
          end

          def target = 'confirm-dialog-cancel-licence'

          def render?
            can?(:update, ::Licence)
          end
        end
      end
    end
  end
end
