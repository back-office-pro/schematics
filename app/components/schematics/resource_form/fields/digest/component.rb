# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      module Digest
        class Component < ApplicationComponent
          option :form
          option :field, optional: true
          option :name, default: proc { :password }, reader: false
          option :icon, default: proc { :key }, reader: false
          option :required, default: proc { true }
          option :confirm, default: proc { false }
          option :autocomplete, default: proc { true }, reader: false

          def data = { action: 'click->password#toggle' }

          def icon
            field.try(:icon) || @icon
          end

          def inputs_count
            confirm? ? 2 : 1
          end

          def name
            field.try(:name) || @name
          end

          def required?
            return field.required? if field

            required
          end

          private

          def autocomplete
            'new-password' unless @autocomplete
          end

          def confirm?
            return field.confirm? if field

            confirm
          end
        end
      end
    end
  end
end
