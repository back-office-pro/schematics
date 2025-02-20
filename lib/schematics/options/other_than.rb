# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class OtherThan < CollectionOption
      class << self
        def input_type = :integer

        def min = nil
      end
    end
  end
end
