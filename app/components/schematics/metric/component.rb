# Copyright © 2025 Dev & Software. All rights reserved.

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
