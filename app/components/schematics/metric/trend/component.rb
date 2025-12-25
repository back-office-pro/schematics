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
