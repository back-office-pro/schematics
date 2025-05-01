# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class AspectRatio < Option
      class << self
        def input_type = :select

        def multiple? = true

        def controller = 'dropdown'

        def collection = %w[landscape square is_16_9 is_4_3]
          .map { [I18n.t(_1, scope: %i[activemodel attributes schematics/options/wrapper aspect_ratios]), _1] } # rubocop:disable Layout/LineLength
          .sort
      end
    end
  end
end
