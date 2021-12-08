# frozen_string_literal: true

require 'active_support'
require 'action_view/helpers/number_helper'

module Schematics
  module Virtuals
    class Calculation < Virtual
      include Behaviours::Rangeable
      include ActionView::Helpers::NumberHelper

      delegate :unit, :scale, to: :options

      def to_sql
        super.join
      end

      def format(value)
        case value
        when StandardError
          super
        else
          return number_to_human_size(value) if unit == 'bytes'

          [scale ? value.round(scale) : value, unit].compact.join(' ')
        end
      end

      def icon
        :square_root_alt
      end
    end
  end
end
