# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Digest
        class Component < ApplicationComponent
          option :form
          option :field, optional: true
          option :name, default: -> { :password }
          option :icon, default: -> { :key }
          option :required, default: -> { true }
          option :confirm, default: -> { false }
          option :autocomplete, default: -> { 'current-password' }

          def data = { action: 'click->password#toggle' }

          def icon
            field.try(:icon) || super
          end

          def inputs_count
            confirm? ? 2 : 1
          end

          def name
            field.try(:name) || super
          end

          def required?
            return field.required? if field

            required
          end

          def eye_icons
            fa_icon(:eye, class: 'icon', role: 'button', data:) +
              fa_icon(:eye_slash, class: 'icon d-none', role: 'button', data:)
          end

          private

          def confirm?
            return field.confirm? if field

            confirm
          end
        end
      end
    end
  end
end
