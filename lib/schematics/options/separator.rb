# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class Separator < Option
      class << self
        def input_type = :select

        def controller = 'dropdown'

        def multiple? = false

        def collection = %w[, .]
      end
    end
  end
end
