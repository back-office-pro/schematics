# frozen_string_literal: true

module Schematics
  module Attributes
    class Duration < Integer
      include Behaviours::Unincrementable

      def format(value)
        value && ActiveSupport::Duration.build(value).inspect
      end

      def openai_description = 'An attribute which represents a duration'

      def icon = :hourglass
    end
  end
end
