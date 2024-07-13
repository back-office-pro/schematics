# frozen_string_literal: true

module Schematics
  module Options
    class Exclude < Option
      class << self
        def hidden? = true

        def input_type = :select
      end
    end
  end
end
