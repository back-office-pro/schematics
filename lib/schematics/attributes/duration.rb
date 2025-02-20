# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    class Duration < Integer
      include Behaviours::Unincrementable

      def format(value)
        value && ActiveSupport::Duration.build(value).inspect
      end

      def icon = :hourglass
    end
  end
end
