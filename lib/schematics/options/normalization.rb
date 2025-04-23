# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class Normalization < Option
      class << self
        def input_type = :select

        def controller = 'dropdown'

        def multiple? = false

        def collection = %w[capitalize upcase downcase]
          .map { [I18n.t(_1, scope: %i[activemodel attributes schematics/options/wrapper normalizations]), _1] } # rubocop:disable Layout/LineLength
          .sort
      end
    end
  end
end
