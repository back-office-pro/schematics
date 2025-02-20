# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Metric
    class Component < ApplicationComponent
      delegate :id,
               :icon,
               :value,
               :threshold,
               :exceeded?,
               :value_formatted,
               :model_class,
               to: :@metric
      with_collection_parameter :metric

      attr_reader :metric

      def initialize(metric:)
        super
        @metric = metric
      end

      def background_css_class
        return 'bg-danger' if exceeded?

        'bg-success'
      end

      def percentage
        value.to_f * 100 / threshold
      end

      def render?
        can?(:show, @metric)
      end
    end
  end
end
