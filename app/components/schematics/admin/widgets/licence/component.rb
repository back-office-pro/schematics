# frozen_string_literal: true

module Schematics
  module Admin
    module Widgets
      module Licence
        class Component < ApplicationComponent
          delegate :icon, to: '::Licence.entity'
          delegate :inactive?, to: :resource

          memoize def resource = ::Licence.instance

          def target = 'confirm-dialog-cancel-licence'

          def render?
            can?(:cancel, ::Licence)
          end
        end
      end
    end
  end
end
