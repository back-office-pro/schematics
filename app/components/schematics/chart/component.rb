# frozen_string_literal: true

module Schematics
  module Chart
    class Component < ApplicationComponent
      delegate :icon, :kind, :suffix, :type, :xtitle, :ytitle, to: :@chart

      def initialize(chart:)
        super
        @chart = chart
      end

      def id
        "chart-#{@chart.id}"
      end

      def filename
        @chart.to_s.parameterize
      end

      def border_width
        (%w[line area].include?(kind) && 1) || 0
      end
    end
  end
end
