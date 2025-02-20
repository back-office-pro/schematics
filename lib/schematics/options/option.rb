# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class Option
      delegate :hidden?, :option_name, to: :class

      class << self
        def hidden? = false

        def option_name = name
          .demodulize
          .underscore
          .to_sym
      end
    end
  end
end
