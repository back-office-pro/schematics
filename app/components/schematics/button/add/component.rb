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
  module Button
    module Add
      class Component < ApplicationComponent
        delegate :human_name, :gender, to: :model_class
        option :model_class
        option :resource, optional: true

        def data = {
          turbo_frame: '_top',
          controller: 'tooltip',
          'bs-custom-class': 'responsive-button-tooltip-lg'
        }

        def title = t('schematics.application.button.add', human_name:, gender:)

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-1]

        def path
          return new_resource_path(model_class) unless resource

          new_comment_resource_path(resource)
        end

        def render?
          can?(:new, model_class)
        end
      end
    end
  end
end
