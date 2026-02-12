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
  module Chart
    module Helper
      class Component < ApplicationComponent
        option :chart
        option :dashboard_id, optional: true
        option :data, optional: true
        option :animation, default: -> { true }
        option :height, default: -> { '300px' }

        delegate :kind,
                 :xtitle,
                 :ytitle,
                 :entity_y_field,
                 :color,
                 to: :chart

        def id = dom_id(*[chart, dashboard_id].compact)

        def data
          super || url
        end

        def empty = t('.empty')

        def type = :"#{kind}_chart"

        def filename = chart
          .to_s
          .parameterize

        def colors = color
          .dup
          .paint
          .palette
          .analogous(as: :hex)

        def border_width
          (%w[line area].include?(kind) && 1) || 0
        end

        def bytes
          (entity_y_field in Schematics::Attributes::Byte) || unit.eql?('bytes')
        end

        def prefix
          unit unless suffix
        end

        def suffix
          unit if unit.eql?('%') || !default_number_format[:format].start_with?('%u')
        end

        def decimal
          entity_y_field.try(:separator) || default_number_format[:separator]
        end

        def precision
          entity_y_field.try(:precision) || default_number_format[:precision]
        end

        def thousands
          entity_y_field.try(:delimiter) || default_number_format[:delimiter]
        end

        private

        def url = resource_path(chart, format: :json)

        def unit
          entity_y_field.try(:unit)
        end

        def default_number_format = t('number.currency.format')
      end
    end
  end
end
