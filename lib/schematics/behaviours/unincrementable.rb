# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Behaviours
    module Unincrementable
      def available_options = super.excluding(Options::AutoIncrement)

      def auto_increment? = false
    end
  end
end
