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
    module ResourceLink
      class Component < ApplicationComponent
        renders_one :body
        delegate :deleted?, to: :resource, private: true
        option :resource
        option :tag_name, default: -> { :div }
        option :css_classes, optional: true

        def data
          return unless visitable?

          {
            action: 'click->application#visit',
            'application-href-param': resource_path(resource)
          }
        end

        def role
          return unless visitable?

          'button'
        end

        private

        def visitable?
          !deleted? && can?(:show, resource)
        end
      end
    end
  end
end
