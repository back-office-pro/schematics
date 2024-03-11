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

      def initialize(chart:)
        super
        @chart = chart
      end

      def css_id = "chart-#{id}"

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
