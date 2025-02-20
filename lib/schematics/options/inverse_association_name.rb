# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Options
    class InverseAssociationName < Option
      class << self
        def hidden? = true

        def input_type = :string
      end
    end
  end
end
