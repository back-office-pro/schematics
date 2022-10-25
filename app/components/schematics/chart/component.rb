# frozen_string_literal: true

module Schematics
  module Chart
    class Component < ApplicationComponent
      with_collection_parameter :chart
      delegate :icon,
               :kind,
               :suffix,
               :type,
               :xtitle,
               :ytitle,
               :css_id,
               :filename,
               :border_width,
               to: :@chart

      def initialize(chart:)
        super
        @chart = chart
      end
    end
  end
end
