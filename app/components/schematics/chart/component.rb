# frozen_string_literal: true

module Schematics
  module Chart
    class Component < ApplicationComponent
      with_collection_parameter :chart
      delegate :id, :icon, :size, to: :@chart

      def initialize(chart:, id:)
        super
        @chart = chart
        @dashboard_id = id
      end

      def col_classes = [
        "col-xl-#{col_size}",
        "col-md-#{max_col_size}"
      ]

      def render?
        can?(:show, @chart)
      end

      private

      def col_size = ::Chart
        .sizes
        .transform_values { it.next * 3 }
        .fetch(size)

      def max_col_size = [12, col_size * 2].min
    end
  end
end
