# frozen_string_literal: true

module Schematics
  module Options
    class Option
      class << self
        def name = super
          .demodulize
          .underscore
          .to_sym
      end
    end
  end
end
