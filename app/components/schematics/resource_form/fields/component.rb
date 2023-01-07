# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      class Component < ApplicationComponent
        delegate :name, :icon, :required?, to: :field
        delegate :layout, to: :form

        option :form
        option :field

        alias required required?

        def prepend
          return if inline?

          fa_icon(icon)
        end

        def wrapper
          return unless inline?

          false
        end

        def hide_label
          return false unless inline?

          true
        end

        def control_class
          return 'form-control' unless inline?

          'form-control form-control-sm px-2 py-0'
        end

        def include_hidden = false

        def resource = form.object

        def value = resource.public_send(name.to_sym)

        protected

        def inline?
          layout == :inline
        end
      end
    end
  end
end
