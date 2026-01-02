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
  module Admin
    module Widgets
      module License
        class Component < ApplicationComponent
          delegate :active?, :expires_at, to: '::Configuration.license'

          def icon = :id_badge

          def text_css_class
            return 'text-success' if active?

            'text-danger'
          end

          def text
            return t('.active') if active?

            t('.inactive')
          end

          def col_css_classes
            return %w[p-4] if active?

            %w[p-3 m-1]
          end

          def expires_at_formatted
            I18n.l(Time.zone.at(expires_at), format: :long)
          end
        end
      end
    end
  end
end
