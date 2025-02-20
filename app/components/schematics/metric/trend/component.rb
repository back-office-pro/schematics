# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Metric
    module Trend
      class Component < ApplicationComponent
        MAX_PERCENTAGE = 9999

        delegate :trend, :trend_progress, to: :metric, private: true
        delegate :positive?, :negative?, :nonzero?, to: :trend, private: true
        option :metric

        def icon
          return :arrow_trend_up if positive?

          :arrow_trend_down if negative?
        end

        def css_class
          return 'text-success' if positive?

          'text-danger' if negative?
        end

        def percentage
          [(trend_progress.infinite? || trend_progress) * 100, MAX_PERCENTAGE].min
        end

        alias render? nonzero?
      end
    end
  end
end
