# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class Width < Option
      class << self
        def input_type = :integer

        def min = 0
      end
    end
  end
end
