# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      class Component < ApplicationComponent
        delegate :available_locales, to: ::Configuration
        delegate :name, :icon, :options, :required?, to: :field
        delegate :layout, to: :form

        option :form
        option :field

        alias required required?

        def prepend
          return if inline?

          fa_icon(icon)
        end

        def hide_label
          return false unless inline?

          true
        end

        def control_class
          return %w[form-control] unless inline?

          %w[form-control form-control-sm rounded px-2 py-0]
        end

        def include_hidden = false

        def multiple = true

        def switch = true

        def resource = form.object

        def value = resource.public_send(name.to_sym)

        def i18n_label(locale)
          translate(
            locale,
            scope: %i[schematics application resource_form field],
            attribute_name: resource.class.human_attribute_name(name)
          )
        end

        protected

        def inline?
          layout == :inline
        end
      end
    end
  end
end
