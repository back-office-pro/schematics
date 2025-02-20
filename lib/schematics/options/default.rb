# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class Default < Option
      class << self
        def input_type = :polymorphic
      end
    end
  end
end
