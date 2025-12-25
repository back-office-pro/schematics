# Copyright © 2025 Dev & Software. All rights reserved.
#
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
