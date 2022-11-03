# frozen_string_literal: true

module Schematics
  module Options
    class Values < Option
      class << self
        def input_type = :array
      end
    end
  end
end
