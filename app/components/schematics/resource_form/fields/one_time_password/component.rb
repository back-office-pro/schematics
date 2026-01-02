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
      module OneTimePassword
        class Component < ApplicationComponent
          option :form
          option :field, optional: true
          option :name, optional: true
          option :required, default: -> { true }

          def digits = ::ActiveModel::OneTimePassword::OTP_DEFAULT_DIGITS

          def hide_label = true # rubocop:disable Naming/PredicateMethod

          def multiple = true # rubocop:disable Naming/PredicateMethod

          def inputmode = 'numeric'

          def autocomplete = 'one-time-code'

          def wrapper_class = 'float-start me-2'

          def control_class = 'form-control form-control-lg text-center otp-digit-input'

          def pattern = '[0-9]'

          def maxlength = 1

          def data = {
            'one-time-password-target': 'digit',
            action: %w[
              input->one-time-password#input
              paste->one-time-password#paste:prevent
              keydown.left->one-time-password#navigateLeft:prevent
              keydown.right->one-time-password#navigateRight:prevent
            ].join(' ')
          }

          def name
            field.try(:name) || super
          end

          def required
            return field.required? if field

            super
          end

          def attribute_name = form
            .object
            .class
            .human_attribute_name(name)

          def label_css_classes = class_names('form-label', required:)
        end
      end
    end
  end
end
