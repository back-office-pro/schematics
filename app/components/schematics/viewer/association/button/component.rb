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
  module Viewer
    module Association
      module Button
        class Component < ApplicationComponent
          delegate :reflection, :owner, :klass, to: :proxy_association, allow_nil: true
          delegate :inverse_of, to: :reflection, allow_nil: true, private: true
          option :proxy_association

          def data = { controller: 'tooltip' }

          def title = t('.title')

          def icon = :list

          def css_classes = %w[btn]

          def filter = { inverse_of&.name => owner&.to_s }

          def render? = filter
            .keys
            .any?
        end
      end
    end
  end
end
