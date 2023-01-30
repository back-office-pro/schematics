# frozen_string_literal: true

module Schematics
  module Attributes
    class Duration < Integer
      def format(value)
        value && ActiveSupport::Duration.build(value).inspect
      end

      def icon = :hourglass
    end
  end
end
