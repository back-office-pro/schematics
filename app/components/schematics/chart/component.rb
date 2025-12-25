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
  module Chart
    class Component < ApplicationComponent
      with_collection_parameter :chart
      delegate :id,
               :icon,
               :kind,
               :suffix,
               :type,
               :xtitle,
               :ytitle,
               :col_size,
               :max_col_size,
               :filename,
               :border_width,
               :colors,
               to: :@chart

      def initialize(chart:, id:)
        super
        @chart = chart
        @dashboard_id = id
      end

      def css_id = dom_id(@chart, @dashboard_id)

      def empty = t('schematics.application.resource.empty')

      def col_classes = [
        "col-xl-#{col_size}",
        "col-md-#{max_col_size}"
      ]

      def render?
        can?(:show, @chart)
      end
    end
  end
end
