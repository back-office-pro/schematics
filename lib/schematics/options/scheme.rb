# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class Scheme < Option
      class << self
        def input_type = :select

        def controller = 'dropdown'

        def multiple? = true

        def collection = %w[http https]
      end
    end
  end
end
