# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class Icon < Option
      class << self
        def input_type = :select

        def multiple? = false

        def controller = 'dropdowns--fa-icons-dropdown'

        def collection = YAML
          .load_file(File.expand_path('../../icons.yml', __dir__))
          .map(&:to_sym)
      end
    end
  end
end
