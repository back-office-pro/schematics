# frozen_string_literal: true

module Schematics
  module Metric
    class Component < ApplicationComponent
      delegate :id,
               :icon,
               :value,
               :trend,
               :threshold,
               :exceeded?,
               :value_formatted,
               :model_class,
               to: :@metric
      with_collection_parameter :metric

      def initialize(metric:)
        super
        @metric = metric
      end

      def background_css_class
        return 'bg-danger' if exceeded?

        'bg-success'
      end

      def percentage
        value * 100 / threshold
      end

      def trend_icon
        return :arrow_trend_up if trend.positive?

        :arrow_trend_down if trend.negative?
      end

      def trend_icon_css_classes
        return %w[fa-lg ms-1 text-success] if trend.positive?

        %w[fa-lg ms-1 text-danger] if trend.negative?
      end

      def render?
        can?(:show, @metric)
      end
    end
  end
end
