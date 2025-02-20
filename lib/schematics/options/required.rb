# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class Required < Option
      class << self
        def input_type = :boolean
      end
    end
  end
end
