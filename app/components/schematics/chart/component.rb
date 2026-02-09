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
    class Component < ApplicationComponent
      with_collection_parameter :chart
      delegate :id,
               :icon,
               :kind,
               :xtitle,
               :ytitle,
               :size,
               :entity_y_field,
               :color,
               to: :@chart

      def initialize(chart:, id:)
        super
        @chart = chart
        @dashboard_id = id
      end

      def css_id = dom_id(@chart, @dashboard_id)

      def empty = t('schematics.application.resource.empty')

      def type = :"#{kind}_chart"

      def height = '300px'

      def filename = @chart
        .to_s
        .parameterize

      def col_classes = [
        "col-xl-#{col_size}",
        "col-md-#{max_col_size}"
      ]

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

      def render?
        can?(:show, @chart)
      end

      private

      def col_size = ::Chart
        .sizes
        .transform_values { _1.next * 3 }
        .fetch(size)

      def max_col_size = [12, col_size * 2].min

      def unit
        entity_y_field.try(:unit)
      end

      def default_number_format = t('number.currency.format')
    end
  end
end
