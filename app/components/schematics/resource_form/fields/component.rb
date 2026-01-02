# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module ResourceForm
    module Fields
      class Component < ApplicationComponent
        delegate :available_locales, to: '::Configuration'
        delegate :name, :icon, :options, :required?, to: :field
        delegate :layout, to: :form

        with_collection_parameter :field

        attr_reader :field, :form

        def initialize(field:, form:)
          super
          @field = field
          @form = form
        end

        alias required required?

        def prepend
          return if inline?

          fa_icon(icon)
        end

        def hide_label # rubocop:disable Naming/PredicateMethod
          return false unless inline?

          true
        end

        def control_class
          return %w[form-control] unless inline?

          %w[form-control form-control-sm rounded px-2 py-0]
        end

        def include_hidden = false # rubocop:disable Naming/PredicateMethod

        def multiple = true # rubocop:disable Naming/PredicateMethod

        def switch = true # rubocop:disable Naming/PredicateMethod

        def resource = form.object

        def value = resource.public_send(name.to_sym)

        def i18n_label(locale)
          return attribute_name if available_locales.one?

          translate(
            locale,
            scope: %i[schematics application resource_form field],
            attribute_name:
          )
        end

        protected

        def inline?
          layout == :inline
        end

        def attribute_name = resource
          .class
          .human_attribute_name(name)
      end
    end
  end
end
