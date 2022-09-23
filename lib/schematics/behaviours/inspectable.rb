# frozen_string_literal: true

module Schematics
  module Behaviours
    module Inspectable
      def inspect = "#{name}:#{type}"

      def type = self
        .class
        .name
        .demodulize
        .underscore
    end
  end
end
