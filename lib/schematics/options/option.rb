# frozen_string_literal: true

module Schematics
  module Options
    class Option
      delegate :hidden?, :name, to: :class

      class << self
        def hidden? = false

        def name = super
          .demodulize
          .underscore
          .to_sym
      end
    end
  end
end
