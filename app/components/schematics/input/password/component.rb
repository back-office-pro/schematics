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

        def autocomplete
          'new-password' unless @autocomplete
        end

        def confirm?
          return @field.confirm? if @field

          @confirm
        end

        def data = {
          action: 'click->password#toggle'
        }

        def icon
          @field.try(:icon) || @icon
        end

        def input_html = {
          autocomplete:,
          'data-password-target': 'input'
        }.compact

        def inputs_count
          confirm? ? 2 : 1
        end

        def name
          @field.try(:name) || @name
        end

        def required?
          return @field.required? if @field

          @required
        end
      end
    end
  end
end
