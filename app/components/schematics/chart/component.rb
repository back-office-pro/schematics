# Copyright © 2025 Dev & Software. All rights reserved.
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
