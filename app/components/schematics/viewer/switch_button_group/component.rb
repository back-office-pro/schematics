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
  module Viewer
    module SwitchButtonGroup
      class Component < ApplicationComponent
        delegate :id, :deleted?, to: :resource
        option :resource
        option :resources

        def data = {
          action: 'click->comparison#toggleButton click->bulk-action#toggleButton',
          'comparison-target': 'switch',
          'bulk-action-target': 'switch'
        }

        def render?
          multi_resources? && (can_compare? || can_archive?) && !deleted?
        end

        private

        def multi_resources?
          resources.reject(&:deleted?).size > 1 # rubocop:disable Performance/Count
        end

        def can_compare?
          can?(:create, ::Comparison) && can?(:show, resource)
        end

        def can_archive?
          can?(:archive, resource)
        end
      end
    end
  end
end
