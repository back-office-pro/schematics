# frozen_string_literal: true

module Schematics
  module Input
    module Password
      class Component < ApplicationComponent
        # :reek:LongParameterList
        def initialize( # rubocop:disable Metrics/ParameterLists
          form:,
          field: nil,
          name: :password,
          icon: :key,
          required: true,
          confirm: false,
          autocomplete: true
        )
          super
          @form = form
          @field = field
          @name = name
          @icon = icon
          @required = required
          @confirm = confirm
          @autocomplete = autocomplete
        end

        def name
          @field.try(:name) || @name
        end

        def icon
          @field.try(:icon) || @icon
        end

        def autocomplete
          'new-password' unless @autocomplete
        end

        def required?
          return @field.required? if @field

          @required
        end

        def confirm?
          return @field.confirm? if @field

          @confirm
        end

        def inputs_count
          confirm? ? 2 : 1
        end

        def input_html
          { autocomplete:, 'data-form-target': 'passwordInput' }.compact
        end

        def data
          { action: 'click->form#togglePasswordValue' }
        end
      end
    end
  end
end
